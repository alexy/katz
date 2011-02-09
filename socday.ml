open Common
open Sgraph

let socDay socUserDaySum sgraph params day =
  let (alpha, beta, gamma, by_mass, skew_times) = params in
  let {ustatsSG =ustats} = sgraph in

  (* TODO how do we employ const |_ ... instead of the lambda below? *)
  let termsStats = H.map (socUserDaySum sgraph day) ustats in
  let sumTerms   = termsStats |> H.values |> enumCatMaybes in
  let (outSum,inSumBack,inSumAll) as norms = Enum.fold (fun (x,y,z) (x',y',z') -> (x+.x',y+.y',z+.z')) 
                        (0.,0.,0.) sumTerms in
  leprintfln "day %d norms: [%F %F %F]" day outSum inSumBack inSumAll;
  
  let skews = usersHash () in

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

    if not (H.is_empty ins) then 
     begin (* TODO outs are from dm's, ins are from dr's!  Revert? *)
       let rewards_contributions = H.map begin fun mentioner nments -> 
         let nreps = H.find_default outs mentioner 0 in
         nreps,nments
       end ins |> H.values |> A.of_enum in

       A.sort (fun (_,x) (_,y) -> compare y x) rewards_contributions;
       let rewards, contributions = array_split rewards_contributions in
       let skew'  = Skew.skew ~by_mass ~skew_times rewards contributions in
       if skew' <> [] then skews <-- (user,skew') else ()
     end else ();
     stats' in
    
  hashUpdateWithImp tick ustats termsStats;
  skews