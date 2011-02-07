open Common

let getUserDay = Dreps.getUserDay

let emptyTalk : talk_balance = H.create Constants.repsN

let orderN       = Constants.usersN
let usersHash () = H.create orderN
