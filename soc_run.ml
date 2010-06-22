open   Batteries_uni
open   Graph
open   Option
module H=Hashtbl
open   Utils

type dCaps = (user,(int * float) list) H.t
type talkBalance = (user,int) H.t
let emptyTalk () = H.create 100

type userStats = {
    socUS  : float;
    dayUS  : int;
    insUS  : talkBalance;
    outsUS : talkBalance;
    totUS  : talkBalance;
    balUS  : talkBalance }

let newUserStats soc day = 
  {socUS = soc; dayUS = day;
  insUS = emptyTalk (); outsUS = emptyTalk (); 
  totUS = emptyTalk (); balUS = emptyTalk () }

type uStats = (user,userStats) H.t

type socRun = { alphaSR : float; betaSR : float; gammaSR : float;
                      socInitSR : float; maxDaysSR : int option }
                      
let optSocRun : socRun = 
  { alphaSR = 0.00001; betaSR = 0.5; gammaSR = 0.5; 
    socInitSR = 1.0; maxDaysSR = None }

type sGraph = 
  {drepsSG : graph; dmentsSG : graph; 
   dcapsSG : dCaps; ustatsSG : uStats}

let paramSC {alphaSR =a; betaSR =b; gammaSR =g} = (a, b, g)

let minMax1 (oldMin, oldMax) x =
  let newMin = min oldMin x in
  let newMax = max oldMax x in
  (newMin, newMax)

let minMax2 (oldMin, oldMax) (x,y) =
  let newMin = min oldMin x in
  let newMax = max oldMax y in
  (newMin, newMax)

(* find the day range when each user exists in dreps *)

let dayRanges dreps = 
    let doDays _ doReps =
        if H.is_empty doReps then None
        else
          let days = H.keys doReps in
          let aDay = match Enum.peek days with 
            | Some day -> day
            | _ -> failwith "should have some days here" in
          let dayday = (aDay,aDay) in
          let ranges = Enum.fold (fun res elem -> minMax1 res elem) dayday days in
          Some ranges
    in
    H.filter_map doDays dreps
    

let safeDivide x y = if y == 0. then x (* really?  or 0? *) else x /. y

let safeDivide3 (x,y,z) (x',y',z') =
  let a = safeDivide x x' in
  let b = safeDivide y y' in
  let c = safeDivide z z' in
  (a,b,c)

let getUserDay usr day m =
      match H.find_option m usr with
        | Some m' -> H.find_option m' day
        | None -> None

let getSocCap ustats user =
  match H.find_option ustats user with
    | Some stats -> stats.socUS
    | _ -> 0.


let socUserDaySum sgraph day user =
  let {drepsSG =dreps; dmentsSG =dments; ustatsSG =ustats} = sgraph in
  let stats = H.find ustats user in
  let dr_ = getUserDay user day dreps in
  let dm_ = getUserDay user day dments in
  if not (is_some dr_ || is_some dm_) then
    (None, stats)
  else begin (* begin..end extraneous around the let chain? *)
    let {socUS =soc; dayUS =day; insUS =ins; outsUS =outs; totUS =tot; balUS =bal} = stats in
    
    let outSum =
      match dr_ with
        | None -> 0.
        | Some dr ->
        	leprintf "user: %s, dr size: %d" user (H.length dr);
            let step to' num res = 
              let toBal = H.find_default bal to' 0 in
              if toBal >= 0 then 0.
              else begin (* although else binds closer, good to demarcate *)
                let toSoc = getSocCap ustats to' in
                  if toSoc == 0. then 0.
                  else
                    let toTot = H.find_default tot to' 1 in
                    let term = float (num * toBal * toTot) *. toSoc in
                    res +. term
              end
            in
            H.fold step dr 0. in

    let (inSumBack,inSumAll) =
          match dm_ with
            | None -> (0.,0.)
            | Some dm ->
                let step to' num (backSum,allSum) =
                  let toBal = H.find_default bal to' 0 in
                  let toSoc = getSocCap ustats to' in
                  if toSoc == 0. then (0.,0.)
                  else begin
                    let toTot = H.find_default tot to' 1 in
                    let allTerm  = float (num * toTot) *. toSoc in
                    let backTerm = if toBal <= 0 then 0. else float toBal *. allTerm in
                    (backSum +. backTerm,allSum +. allTerm)
                  end
                in  
                H.fold step dm (0.,0.) in

    let terms = (outSum, inSumBack, inSumAll) in

    let addMaps      = hashMergeWith (+) in
    let subtractMaps = hashMergeWith (-) in

    let ins'  = match dr_ with | Some dr -> addMaps ins dr  | _ -> ins in
    let outs' = match dm_ with | Some dm -> addMaps outs dm | _ -> outs in
	
    let (tot', bal') =
      match (dr_, dm_) with
        | (Some dr, None) -> (addMaps tot dr, addMaps bal dr)
        | (None, Some dm) -> (addMaps tot dm, subtractMaps bal dm)
        | (Some dr, Some dm) ->
          let t = addMaps tot dm      |> addMaps dr in
          let b = subtractMaps bal dm |> addMaps dr in
          (t,b) 
        | (None,None) -> failwith "gotta have dr or dm here"  
          in

    let stats' = {stats with insUS= ins'; outsUS= outs'; totUS= tot'; balUS= bal'} in
    (Some terms, stats')
  end


let socDay sgraph params day =
  let (alpha, beta, gamma) = params in
  let {ustatsSG =ustats; dcapsSG =dcaps} = sgraph in
    (* or is it faster to dot fields:
    let ustats = sgraph.ustatsSG in
    let dcaps  = sgraph.dcapsSG in *)

  (* TODO how do we employ const |_ ... instead of the lambda below? *)
  let termsStats = H.map (fun user _ -> socUserDaySum sgraph day user) ustats in
  let sumTerms   = termsStats |> H.values |> Enum.map fst |> enumCatMaybes in
  let norms = Enum.fold (fun (x,y,z) (x',y',z') -> (x+.x',y+.y',z+.z')) (0.,0.,0.) sumTerms in

  (* : user -> ((float * float * float) option * userStats) -> userStats *)
  let tick _ (numers,stats)  = 
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
    
  let ustats' : uStats = H.map tick termsStats in
  
  let updateUser user stats res =
    let soc = stats.socUS in
    let caps  = H.find_default res user [] in
    let caps' = (day,soc)::caps in
    H.replace res user caps';
    res in

  let dcaps' = H.fold updateUser ustats' dcaps in
  { sgraph with ustatsSG= ustats'; dcapsSG= dcaps'}
  

let socRun dreps dments opts =
    let params  = paramSC opts in
    let socInit = opts.socInitSR in
    let orderN  = 1000000 in
    let dcaps   = H.create orderN in
    let ustats  = H.create orderN in
    let sgraph  = {drepsSG=dreps; dmentsSG=dments; dcapsSG=dcaps; ustatsSG=ustats} in
    let dranges = hashMergeWith minMax2 (dayRanges dreps) (dayRanges dments) in
    let dstarts = H.fold (fun user (d1,d2) res -> 
        let users = H.find_default res d1 [] in H.replace res d1 (user::users); res) dranges (H.create 100000) in    
    let (firstDay,lastDay) = H.fold (fun _ v res -> minMax2 v res) dranges (dranges |> hashFirst |> snd) in
    leprintfln "doing days from %d to %d" firstDay lastDay;
    
    (* inject the users first appearing in this cycle *)
    let tick sgraph day =
      let nus = newUserStats socInit day in
      let ustats = sgraph.ustatsSG in
      let newUsers = H.find dstarts day in
      leprintfln "adding %d users on day %d" (List.length newUsers) day;
      (* TODO: will newUS be copied upon each new insertion? *)
      let ustats' = List.fold_left (fun res user -> H.add ustats user nus; res)
      	 ustats newUsers in
      leprintfln "now got %d" (H.length ustats'); 
      let sgraph' = {sgraph with ustatsSG = ustats'} in 
      socDay sgraph' params day
    in
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    Enum.fold tick sgraph theDays
