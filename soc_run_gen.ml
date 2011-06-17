open Common
include Sgraph
let socDay = Socday.socDay Suds.socUserDaySum

type socRun = { alphaSR : float; betaSR : float; gammaSR : float;
                socInitSR : float; 
                useInAllSR : bool; inAllDownSR : bool; 
                byMassSR : bool; skewTimesSR : int;
                minCapDaysSR : int; minCapSR : float;
                initDrepsSR : graph option; initDaySR : int option;
                maxDaysSR : int option }
                      
let optSocRun : socRun = 
  { alphaSR = 0.1; betaSR = 0.5; gammaSR = 0.5; 
    socInitSR = 1.0; 
    useInAllSR = true; inAllDownSR = false; 
    byMassSR = false; skewTimesSR = 8;
    minCapDaysSR = 7; minCapSR = 1e-35;
    initDrepsSR = None; initDaySR = None; 
    maxDaysSR = None }

let paramSC {alphaSR =a; betaSR =b; gammaSR =g; 
    useInAllSR =use_in_all; inAllDownSR =in_all_down; 
    byMassSR =by_mass; skewTimesSR =skew_times} = 
    (a, b, g, use_in_all, in_all_down, by_mass, skew_times)

let socRun: starts -> day_rep_nums -> socRun -> sgraph * (dcaps * dskews) * timings =
    fun dstarts drnums opts ->
    let params  = paramSC opts in
    let fromNums = A.map (H.map (fun _ v -> fst v)) drnums in
    let {socInitSR =socInit; minCapDaysSR =minCapDays; minCapSR =minCap; 
         initDrepsSR =initDreps; initDaySR =initDay} = opts in

    let dcaps     = usersHash () in
    let dskews    = usersHash () in
    let ustats    = usersHash () in

    let dreps,dments = 
    match initDreps with
    | Some dreps ->
      (* when initDreps is Some, initDay must be Some *)
      let beforeDay = Option.get initDay in
      let breps = Dreps.before dreps beforeDay |> 
        H.filter (fun days ->  not (H.is_empty days)) in
      let bments = Invert.invert2 breps in
      breps,bments
    | _ -> usersHash (), usersHash () in

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
      
      begin match initDay with
      | Some before when day < before -> ()
      | _ ->
        let props = mature_caps minCapDays minCap ustats day |> H.enum in
        Simulate.growEdges fromNums.(day) props minCap dreps dments day
      end;
    
      let _,skews = socDay sgraph params day in
      let t = Some (sprintf "day %d timing: " day) |> getTiming in
      H.iter (updateFromUStats dcaps statSoc day) ustats;
      H.iter (updateUserDaily  dskews day) skews;
      t::ts in
      
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    (* this is a two-headed eagle, imperative in sgraph, functional in timings *)
    let timings = Enum.fold tick [] theDays in
    sgraph,(dcaps,dskews),timings