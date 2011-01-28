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
include Soc_run_common

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


let paramSC {alphaSR =a; betaSR =b; gammaSR =g; 
    byMassSR =by_mass; skewTimesSR =skew_times} = 
    (a, b, g, by_mass, skew_times)



let socRun: starts -> day_rep_nums -> socRun -> sGraph * timings =
    fun dstarts drnums opts ->
    let params  = paramSC opts in
    let fromNums = A.map (H.map (fun _ v -> fst v)) drnums in
    let {socInitSR =socInit; minCapDaysSR =minCapDays; minCapSR =minCap; 
         initDrepsSR =initDreps; initDaySR =initDay} = opts in
    let orderN  = Constants.usersN in
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
      let {drepsSG =dreps; dmentsSG =dments; ustatsSG =ustats} = sgraph in
      let newUsers = dstarts.(day) in
      leprintfln "adding %d users on day %d" (List.length newUsers) day;
      List.iter (fun user -> H.add ustats user (newUserStats socInit day)) newUsers;
      leprintfln "now got %d" (H.length ustats);
      
      begin match initDay with
      | Some before when day < before -> ()
      | _ ->
        let props = mature_caps minCapDays minCap ustats day |> H.enum in
        Simulate.growEdges fromNums.(day) props minCap dreps dments day
      end;
    
      socDaySkew sgraph params day;
      let t = Some (sprintf "day %d timing: " day) |> getTiming in
      t::ts in
      
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    (* this is a two-headed eagle, imperative in sgraph, functional in timings *)
    let timings = Enum.fold tick [] theDays in
    (sgraph,timings)
