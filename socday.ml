open Common
open Sgraph_local

let socDay socUserDaySum sgraph params day =
  let (alpha, beta, gamma, by_mass, skew_times) = params in
  let {ustatsSG =ustats; dcapsSG =dcaps; dskewsSG =dskews} = sgraph in
    (* or is it faster to dot fields:
    let ustats = sgraph.ustatsSG in
    let dcaps  = sgraph.dcapsSG in *)

  (* TODO how do we employ const |_ ... instead of the lambda below? *)
  let termsStats = H.map (socUserDaySum sgraph day) ustats in
  let sumTerms   = termsStats |> H.values |> enumCatMaybes in
  let (outSum,inSumBack,inSumAll) as norms = Enum.fold (fun (x,y,z) (x',y',z') -> (x+.x',y+.y',z+.z')) 
                        (0.,0.,0.) sumTerms in
  leprintfln "day %d norms: [%F %F %F]" day outSum inSumBack inSumAll;

  (* : user -> ((float * float * float) option * ustats) -> ustats *)
  let tick : user -> ustats -> terms_stat -> ustats = 
    fun user stats numers ->
    let {socUS =soc; insUS =ins; outsUS =outs} = stats in
    let soc' = 
          match numers with
            | Some numers ->
              let (outs', insBack', insAll') =
                   safeDivide3 numers norms 
              in
              alpha *. soc +. (1. -. alpha) *.
                (beta *. outs' +. (1. -. beta) *.
                  (gamma *. insBack' +. (1. -. gamma) *. insAll'))
            | None -> alpha *. soc in
    let stats' = {stats with socUS = soc'} in
    
    (* TODO we might just keep the pairs as yet anotehr hastbatle;
       we may then finally optimize data structure by sharing inverted pairs...
     *)

    let stats' = 
    if H.length ins = 0 then stats'
    else begin
      let rewards_contributions = H.map begin fun mentioner nments -> 
        let nreps = H.find_default outs mentioner 0 in
        (nreps,nments) 
      end ins |> H.values |> A.of_enum in

      A.sort (fun (_,x) (_,y) -> compare y x) rewards_contributions;
      let rewards, contributions = Utils.array_split rewards_contributions in
      let skew'  = Skew.skew ~by_mass ~skew_times rewards contributions in
      {stats' with skewUS = skew'}
    end in
    stats' in
    
  hashUpdateWithImp tick ustats termsStats;
  
  let updateUser dcaps dskews user stats  =
    let {socUS =soc; skewUS = skew} = stats in
    let caps  = H.find_default dcaps user [] in
    let caps' = (day,soc)::caps in
    H.replace dcaps user caps';
    if skew = []  then ()
    else
      let skews  = H.find_default dskews user [] in
      let skews' = (day,skew)::skews in
      H.replace dskews user skews' in

  H.iter (updateUser dcaps dskews) ustats
