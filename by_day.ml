open Common
open Graph

type user_user = (user,reps) Hashtbl.t
type days = (user_user * user_user) array
type nedges_nusers = int * int
type user_nums = (user, nedges_nusers) Hashtbl.t
type day_edgenums = (user_nums * user_nums) array
type user_int = (user * int)
type user_ints = user_int list
type user_int_stream = (user * int) Enum.t

let by_day: graph -> days = fun g ->

  (* 35 days, we know -- or have to scan all days *)
  let daysN = 35 in
  let usersN = 1000000 in
  let repsN = 10 in
  
  let newReps : int -> user_user = fun usersN -> H.create usersN in
  let res = Array.init daysN (fun _ -> (newReps usersN, newReps usersN)) in

  H.iter begin fun f days ->
    H.iter begin fun day reps ->
      H.iter begin fun t num ->
         
          let (ureps,ments) = res.(day) in

          let ff = begin
            try H.find ureps f 
            with Not_found -> let x = H.create repsN in H.add ureps f x; x
          end in
          hashAdd ff t num;

          let tt = begin
            try H.find ments t
            with Not_found -> let x = H.create repsN in H.add ments t x; x
          end in
          hashAdd tt f num

      end reps
    end days
  end g ;  
  res


let numRepsTwits: user_user -> user_nums =
  fun h -> 
  H.map begin fun k1 v1 -> 
    let nedges = H.fold (fun k2 v2 res -> res + v2) v1 0 in
    let nusers = H.length v1 in
    (nedges,nusers)
  end h
  
let dayEdgenums: days -> day_edgenums = 
  fun a ->
  A.map (fun (r,m) -> (numRepsTwits r, numRepsTwits m)) a


(* these are not used for now
let numUserEdges: day_edgenums -> user_ints =
    fun enums -> A.enum enums |> L.of_enum |> L.map (fun (k,(v,_)) -> (k,v))
    
let numUserUsers: day_edgenums -> user_ints =
    fun enums -> A.enum enums |> L.of_enum |> L.map (fun (k,(_,v)) -> (k,v))
 *)
