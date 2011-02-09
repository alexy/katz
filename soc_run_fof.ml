open Common
include Sgraph
include Simulate_utility_fof
let socDay = Socday.socDay Suds_local.socUserDaySum

type socRun = { alphaSR : float; betaSR : float; gammaSR : float;
                socInitSR : float; byMassSR : bool; skewTimesSR : int;
                minCapDaysSR : int; minCapSR : float;
                initDrepsSR : graph option; initDaySR : int option;
                maxDaysSR : int option;
                jumpProbUtilSR : float; jumpProbFOFSR : float;
                globalStrategySR : attachment_strategy;
                fofStrategySR    : attachment_strategy }
 

let optSocRun : socRun = 
  { alphaSR = 0.1; betaSR = 0.5; gammaSR = 0.5; 
    socInitSR = 1.0; byMassSR = false; skewTimesSR = 8;
    minCapDaysSR = 7; minCapSR = 1e-35;
    initDrepsSR = None; initDaySR = None; 
    maxDaysSR = None;
    jumpProbUtilSR = 0.5; jumpProbFOFSR = 0.2;
    globalStrategySR = GlobalMentionsAttachment;
    fofStrategySR    = FOFMentionsAttachment }


let paramSC {alphaSR =a; betaSR =b; gammaSR =g; 
    byMassSR =by_mass; skewTimesSR =skew_times} = 
    (a, b, g, by_mass, skew_times)


let genOptsSC {jumpProbUtilSR   =jumpProbUtil;   jumpProbFOFSR =jumpProbFOF;
               globalStrategySR =globalStrategy; fofStrategySR =fofStrategy } =
  { jumpProbUtilGO=   jumpProbUtil;   jumpProbFOFGO= jumpProbFOF;
    globalStrategyGO= globalStrategy; fofStrategyGO= fofStrategy }


let socRun: starts -> day_rep_nums -> socRun -> sgraph * dcaps * dskews * (edge_count_list * float) list =
    fun dstarts drnums opts ->
    
    let params, genOpts  = paramSC opts, genOptsSC opts in

    let fromNums = A.map (H.map (fun _ v -> fst v)) drnums in (* TODO ByMass? *)
    let {socInitSR =socInit; minCapDaysSR =minCapDays; minCapSR =minCap; 
         initDrepsSR =initDreps; initDaySR =initDay} = opts in
    
    let dcaps     = usersHash () in
    let ustats    = usersHash () in
    let dskews    = usersHash () in

    let dreps,dments,inDegree,outDegree = 
    match initDreps with
    | Some dreps ->
      (* when initDreps is Some, initDay must be Some *)
      let beforeDay = Option.get initDay in
      let breps = Dreps.before dreps beforeDay |> 
        H.filter (fun days ->  not (H.is_empty days)) in
      let bments = Invert.invert2 breps in
      let binDegree  = Dreps.userTotals bments in
      let boutDegree = Dreps.userTotals breps in
      breps,bments,binDegree,boutDegree
    | _ -> usersHash (), usersHash (),
           usersHash (), usersHash () in

    let sgraph = sgraphInit dreps dments ustats in

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
      
      let edgeCounts = 
      match initDay with
      | Some before when day < before -> emptyHash ()
      | _ ->
        let inDeProps = makeInDegreeProportions inDegree newUsers in
        let fnums = makeFNums ustats in
        let fnofs = makeFNOFs ustats fnums in
        let fnumMents = makeFNumMents ustats inDegree in
        let fnofMents = makeFNOFMents ustats fnumMents in
        let degr = 
        { inDegreeDG=inDegree;
          outDegreeDG=outDegree;
          inDePropsDG=inDeProps;
          fnumsDG=fnums;
          fnofsDG=fnofs;
          fnumMentsDG=fnumMents;
          fnofMentsDG=fnofMents } in
          growUtility genOpts sgraph degr day fromNums.(day) in
    
      let skews = socDay sgraph params day in
      
      let t = Some (sprintf "day %d timing: " day) |> getTiming in
      H.iter (updateFromUStats dcaps statSoc day) ustats;
      H.iter (updateUserDaily  dskews day) skews;
      (edgeCounts |> listHash,t)::ts in
      
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    (* this is a two-headed eagle, imperative in sgraph, functional in timings *)
    let countsTimings = Enum.fold tick [] theDays in
    sgraph,dcaps,dskews,countsTimings
