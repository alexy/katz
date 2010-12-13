open Batteries_uni
open Graph

module H=Hashtbl

type user_user = (user,reps) Hashtbl.t
type days = (user_user * user_user) array

let by_day: graph -> days = fun g ->

  (* 35 days, we know -- or have to scan all days *)
  let daysN = 35 in
  let usersN = 1000000 in
  let repsN = 10 in
  
  let newReps : user_user = H.create usersN in
  let res = Array.init daysN (fun _ -> (newReps, newReps)) in

  H.iter begin fun f days ->
    H.iter begin fun day reps ->
      H.iter begin fun t num ->
         
          let (reps,ments) = res.(day) in

          let ff = begin
            try H.find reps f 
            with Not_found -> let x = H.create repsN in H.add reps f x; x
          end in
          let ft = H.find_default ff t 0 in
          H.replace ff f (ft + num);

          let tt = begin
            try H.find ments t
            with Not_found -> let x = H.create repsN in H.add ments t x; x
          end in
          let tf = H.find_default tt f 0 in
          H.replace tt t (tf + num)

      end reps
    end days
  end g ;
  
  res