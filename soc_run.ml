open Common
include Sgraph
let socUserDaySum = Suds.socUserDaySum

type socRun = { alphaSR : float; betaSR : float; gammaSR : float;
                      socInitSR : float; maxDaysSR : int option }
                      
let optSocRun : socRun = 
  { alphaSR = 0.1; betaSR = 0.5; gammaSR = 0.5; 
    socInitSR = 1.0; maxDaysSR = None }


let paramSC {alphaSR =a; betaSR =b; gammaSR =g} = (a, b, g)


let socDay sgraph params day =
  let (alpha, beta, gamma) = params in
  let {ustatsSG =ustats} = sgraph in
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
    let soc = stats.socUS in
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
    stats' in
    
  hashUpdateWithImp tick ustats termsStats
   
      
let socRun dreps dments opts =
    let params  = paramSC opts in
    let socInit = opts.socInitSR in
    
    let dreps   = usersHash () in
    let dments  = usersHash () in
    let ustats  = usersHash () in
    
    let sgraph  = sgraphInit dreps dments ustats in

    let dcaps   = usersHash () in

    let (dstarts,(firstDay,lastDay)) = Dranges.startsRange dreps dments in

    let lastDay = match opts.maxDaysSR with
      | None -> lastDay
      | Some n -> min lastDay (firstDay + n - 1) in
    leprintfln "%d total users, doing days from %d to %d" (H.length dstarts) firstDay lastDay;
    
    (* inject the users first appearing in this cycle *)
    let tick ts day =
      let ustats = sgraph.ustatsSG in
      let newUsers = H.find dstarts day in
      leprintfln "adding %d users on day %d" (List.length newUsers) day;
      List.iter (fun user -> H.add ustats user (newUserStats socInit day)) newUsers;
      leprintfln "now got %d" (H.length ustats);
      socDay sgraph params day;
      let t = Some (sprintf "day %d timing: " day) |> getTiming in

      H.iter (updateFromUStats dcaps statSoc day) ustats;
      t::ts in
      
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    (* this is a two-headed eagle, imperative in sgraph, functional in timings *)
    let timings = Enum.fold tick [] theDays in
    sgraph,dcaps,timings
