open Common

let daysN = 10
let repsN = 10

let userDays: graph -> user -> adjlist =
  fun g user ->
  try H.find g user
  with Not_found -> let x = H.create daysN in H.add g user x ; x
    
let userDay g user day =
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

