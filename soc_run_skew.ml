open Common
include Sgraph
let socDay = Socday.socDay Suds.socUserDaySum

type socRun = { alphaSR : float; betaSR : float; gammaSR : float;
                socInitSR : float; byMassSR : bool; skewTimesSR : int;
                maxDaysSR : int option }
                      
let optSocRun : socRun = 
  { alphaSR = 0.1; betaSR = 0.5; gammaSR = 0.5; 
    socInitSR = 1.0; byMassSR = false; skewTimesSR = 8; 
    maxDaysSR = None }

let paramSC {alphaSR =a; betaSR =b; gammaSR =g; 
    byMassSR =by_mass; skewTimesSR =skew_times} = 
    (a, b, g, by_mass, skew_times)

let socRun dreps dments opts =
    let params  = paramSC opts in
    let socInit = opts.socInitSR in

    let dreps     = usersHash () in
    let dments    = usersHash () in
    let dcaps     = usersHash () in
    let ustats    = usersHash () in
    let dskews    = usersHash () in

    let sgraph  = sgraphInit dreps dments ustats in

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
      let skews = socDay sgraph params day in
      let t = Some (sprintf "day %d timing: " day) |> getTiming in

      H.iter (updateFromUStats dcaps statSoc day) ustats;
      H.iter (updateUserDaily  dskews day) skews;
      t::ts in
      
    let theDays = Enum.seq firstDay succ (fun x -> x <= lastDay) in
    (* this is a two-headed eagle, imperative in sgraph, functional in timings *)
    let timings = Enum.fold tick [] theDays in
    sgraph,dcaps,dskews,timings
