(* TODO 
	currently we H.fold amd List.fold_left everywhere although
	H.iter and List.iter is possible with Hashtbl; can do that and measure.
	The current style allows to replace with pure Map later with fewer changes.
	
	We also update records even though when their mutable field is changed,
	seems we don't have to.   I.e. instead of
	
	List.iter (fun user -> H.add ustats user ...) newUsers;
	sgraph
	
	-- we do:
	
	let ustats' = List.fold_left (fun user res -> H.add ustats res user ...; res) newUsers ustats in
	{ sgraph with ustatsSG = ustats' }
	
	-- preserving Haskell style; the question is, is it efficient?
*)


open Common
open Option

type dCaps = (user,(int * float) list) H.t

type skew   = float list
type dSkews = (user,(int * skew)  list) H.t

type talkBalance = (user,int) H.t
let emptyTalk : talkBalance = H.create 10

type userStats = {
    socUS  : float;
    skewUS : skew;
    dayUS  : int;
    insUS  : talkBalance;
    outsUS : talkBalance;
    totUS  : talkBalance;
    balUS  : talkBalance }

let newUserStats soc day = 
  {socUS = soc; skewUS = []; dayUS = day;
  insUS = H.copy emptyTalk; outsUS = H.copy emptyTalk; 
  totUS = H.copy emptyTalk; balUS =  H.copy emptyTalk }

type uStats = (user,userStats) H.t

type socRun = { alphaSR : float; betaSR : float; gammaSR : float;
                socInitSR : float; byMassSR : bool; skewTimesSR : int;
                minCapDaysSR : int; minCapSR : float;
                initDrepsSR : graph option; initDaySR : int option;
                maxDaysSR : int option }
                      
let optSocRun : socRun = 
  { alphaSR = 0.1; betaSR = 0.5; gammaSR = 0.5; 
    socInitSR = 1.0; byMassSR = false; skewTimesSR = 8;
    minCapDaysSR = 7; minCapSR = 1e-35;
    initDrepsSR = None; initDaySR = None; 
    maxDaysSR = None }

type sGraph = 
  {drepsSG : graph; dmentsSG : graph; 
   dcapsSG : dCaps; dskewsSG : dSkews;
   ustatsSG : uStats}

type timings = float list

let paramSC {alphaSR =a; betaSR =b; gammaSR =g; 
    byMassSR =by_mass; skewTimesSR =skew_times} = 
    (a, b, g, by_mass, skew_times)


(* let safeDivide x y = if y = 0. then x else x /. y *)
let safeDivide x y = let res = x /. y in
	match classify_float res with
		| FP_nan | FP_infinite -> 0. (* or x? *)
		| _ -> res


(* let safeDivide x y = let res = if y == 0. then x else x /. y in
	let show what = Printf.sprintf "%s in safeDivide => x: %e, y: %e, res: %e, y == 0.: %B" 
		what x y res (y==0.) in
	begin match classify_float res with
		| FP_nan -> failwith (show "nan")
		| FP_infinite -> failwith (show "infinite")
		| _ -> res end *)

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
    
type termsStat = (float * float * float) option

(* hashMergeWithImp changes the first hashtbl given to it with the second *)
let addMaps      = hashMergeWithImp (+)
(* this was a cause of a subtle bug where in hashMergeWithImp 
   we added positive balance for yinteo and geokotophia *)
let subtractMaps = hashMergeWithDefImp (-) 0

(* updates stats in the original ustats! *)
let socUserDaySum : sGraph -> day -> user -> userStats -> termsStat = fun sgraph day user stats -> 
  let {drepsSG=dreps;dmentsSG=dments;ustatsSG=ustats} = sgraph in
  let dr_ = getUserDay user day dreps in
  let dm_ = getUserDay user day dments in
  if not (is_some dr_ || is_some dm_) then
    None
  else (* begin..end extraneous around the let chain? *)
    (* NB: don't match dayUS=day, it will shadow the day parameter! *)
    let {socUS =soc; insUS =ins; outsUS =outs; totUS =tot; balUS =bal} = stats in
    
    let outSum =
      match dr_ with
        | None -> 0.
        | Some dr ->
        	(* leprintf "user: %s, dr size: %d" user (H.length dr); *)
            let step to' num res = 
              let toBal = H.find_default bal to' 0 in
              if toBal >= 0 then res
              else begin (* although else binds closer, good to demarcate *)
                let toSoc = getSocCap ustats to' in
                  if toSoc = 0. then res
                  else
                    let toOut = H.find_default outs to' 1 in
                    let toTot = H.find_default tot  to' 1 in
                    let term = float (num * toBal * toOut) *. toSoc /. float toTot in
                    res -. term (* the term is negative, so we sum positive *)
              end
            in
            H.fold step dr 0. in

    let (inSumBack,inSumAll) =
          match dm_ with
            | None -> (0.,0.)
            | Some dm ->
                let step to' num ((backSum,allSum) as res) =
                  let toSoc = getSocCap ustats to' in
                  if toSoc = 0. then res
                  else begin
                    let toIn  = H.find_default ins to' 1 in
                    let toTot = H.find_default tot to' 1 in
                    let allTerm  = float (num * toIn) *. toSoc /. float toTot in
                    let toBal = H.find_default bal to' 0 in
                    let backTerm = if toBal <= 0 then 0. else float toBal *. allTerm in
                    (backSum +. backTerm,allSum +. allTerm)
                  end
                in  
                H.fold step dm (0.,0.) in

    let terms = (outSum, 
                 inSumBack, 
                 inSumAll) in

     (* flux suggested this HOF to simplify match delineation: *)
    let call_some f v = match v with None -> () | Some v -> f v in
    call_some (addMaps ins)  dr_;
    call_some (addMaps outs) dm_;
    begin match (dr_, dm_) with
      | (Some dr, None) ->     addMaps tot dr; addMaps      bal dr 
      | (None, Some dm) ->     addMaps tot dm; subtractMaps bal dm 
      | (Some dr, Some dm) ->  addMaps tot dr; addMaps      tot dm;
                               addMaps bal dr; subtractMaps bal dm
      | (None,None) -> () end; (* should never be reached in this top-level if's branch *)
    Some terms


let socDay sgraph params day =
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

  (* : user -> ((float * float * float) option * userStats) -> userStats *)
  let tick : user -> userStats -> termsStat -> userStats = 
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
  

let socRun: Dranges.starts -> By_day.day_rep_nums -> socRun -> sGraph * timings =
    fun dstarts drnums opts ->
    let params  = paramSC opts in
    let fromNums = A.map (H.map (fun _ v -> fst v)) drnums in
    let {socInitSR =socInit; minCapDaysSR =minCapDays; minCapSR =minCap; 
         initDrepsSR =initDreps; initDaySR =initDay} = opts in
    let orderN  = 5000000 in
    let dcaps   = H.create orderN in
    let dskews  = H.create orderN in
    let ustats  = H.create orderN in
    let dreps,dments = 
    match initDreps with
    | Some dreps ->
      (* when initDreps is Some, initDay must be Some *)
      let beforeDay = Option.get initDay in
      let breps = Dreps.before dreps beforeDay |> 
        H.filter (fun days ->  not (H.is_empty days)) in
      let bments = Invert.invert2 breps in
      breps,bments
    | _ -> H.create orderN,H.create orderN in

    let sgraph = {drepsSG=dreps; dmentsSG=dments; 
      dcapsSG=dcaps; dskewsSG=dskews; ustatsSG=ustats} in

    (* for simple dstarts from dreps always starting at day 0 *)
    let firstDay = 0 in
    let lastDay = A.length dstarts - 1 in
    let lastDay = match opts.maxDaysSR with
      | None -> lastDay
      | Some n -> min lastDay (firstDay + n - 1) in
      
    leprintfln "%d total users, doing days from %d to %d" 
      (Dranges.startsArrayTotalUsers dstarts) firstDay lastDay;
    
    (* inject the users first appearing in this cycle *)
    let tick ts day =
      let {drepsSG =dreps; dmentsSG =dments; dcapsSG =dcaps; ustatsSG =ustats} = sgraph in
      let newUsers = dstarts.(day) in
      leprintfln "adding %d users on day %d" (List.length newUsers) day;
      List.iter (fun user -> H.add ustats user (newUserStats socInit day)) newUsers;
      leprintfln "now got %d" (H.length ustats);
      
      begin match initDay with
      | Some before when day < before -> 
        let props = Dcaps.mature_caps minCapDays minCap dcaps |> H.enum in
        Simulate.growEdges fromNums.(day) props minCap dreps dments day
      | _ -> ()
      end;
    
      socDay sgraph params day;
      let t = Some (sprintf "day %d timing: " day) |> getTiming in
      t::ts in
      
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    (* this is a two-headed eagle, imperative in sgraph, functional in timings *)
    let timings = Enum.fold tick [] theDays in
    (sgraph,timings)
