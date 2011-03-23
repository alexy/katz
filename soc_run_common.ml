open Common

let getUserDay = Dreps.getUserDay

let emptyTalk : talk_balance = H.create Const.repsN

let orderN       = Const.usersN
let usersHash () = H.create orderN

let updateUserDaily dcaps day user v =
    let vs  = H.find_default dcaps user [] in
    let vs' = (day,v)::vs in
    H.replace dcaps user vs'
  
let updateFromUStats dcaps fetch day user stats =
    let v = fetch stats in
    updateUserDaily dcaps day user v

