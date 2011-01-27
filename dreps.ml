open Common

let daysN = Constants.daysN
let repsN = Constants.repsN

let userDays: graph -> user -> adjlist =
  fun g user ->
  try H.find g user
  with Not_found -> let x = H.create daysN in H.add g user x ; x
    
let userDay: graph -> user -> day -> reps =
  fun g user day ->
  let days = userDays g user in
  try H.find days day
  with Not_found -> let x = H.create repsN in H.add days day x ; x

let addEdge g fromUser toUser day =
    let fromDays = begin
      try H.find g fromUser
      with Not_found -> let x = H.create daysN in H.add g fromUser x ; x
    end in
    let reps = begin
      try H.find fromDays day
      with Not_found -> let x = H.create repsN in H.add fromDays day x ; x
    end in
    (* or just replace the above with
       let reps = userDay g fromUser day *)
    let count = H.find_default reps toUser 0 in
    H.replace reps toUser (succ count)

let dayNums: graph -> user -> (day * int) list =
  fun g user ->
  try 
    let days = H.find g user in 
    H.enum days |> E.map begin fun (day, reps) -> 
      let num = H.fold (fun _ num res -> (res + num)) reps 0 in
      (day,num) 
    end |> List.of_enum 
  with Not_found -> []
  
let userTotals: graph -> reps =
  fun g ->
  H.map begin fun user days ->
    H.fold begin fun _ reps res ->
      H.fold (fun _ num res -> res + num) reps 0
    end days 0
  end g
  
let userDailyTotals: graph -> daily_ints =
  fun g ->
  g |> H.map begin fun user days ->
      let a = H.enum days |> A.of_enum in
      A.sort (fun (day1,_) (day2,_) -> compare day1 day2) a;
      let e = E.empty () in
      let n = 0 in
      A.iter begin fun (day,reps) ->
        let n = n + (H.length reps) in
        E.push e (day,n)
      end a;
      H.of_enum e
    end

let userUser: adjlist -> users_total =
  fun days ->
    let res = H.create repsN in
    H.iter begin fun _ reps ->
      H.iter begin fun user num ->
        let rep = H.find_default res user 0 in
        H.replace res user (rep+num)
      end reps
    end days;
    res
    
let before dreps theDay = 
  H.map begin fun user days -> 
    H.filteri (fun day _ -> day < theDay) days
  end dreps 

(* from soc_run family *)
let getUserDay usr day m =
      match H.find_option m usr with
        | Some m' -> H.find_option m' day
        | None -> None

