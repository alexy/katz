open Common
open Graph

type user_user      = (user,reps) Hashtbl.t
type days           = (user_user * user_user) array
type int_int        = int * int
type denums         = (user * int_int) array
type user_nums      = (user, int_int) Hashtbl.t
type user_nums_pair = user_nums * user_nums
type day_edgenums   = user_nums_pair array
type user_int       = user * int
type user_ints      = user_int Enum.t
type real           = float
type day_real       = day * float
type day_reals      = day_real list
type user_day_reals = (user, day_reals) Hashtbl.t
type user_reals     = (user, real) Hashtbl.t
type day_user_reals = user_reals array

let daysN = 35
let usersN = 1000000
let repsN = 10

let by_day: graph -> days = fun g ->

  (* 35 days, we know -- or have to scan all days *)
  
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


let numUserEdges: user_nums_pair -> user_ints =
    fun enums -> enums |> fst |> H.enum |> E.map (fun (k,(v,_)) -> (k,v))
    
let numUserUsers: user_nums_pair -> user_ints =
    fun enums -> enums |> fst |> H.enum |> E.map (fun (k,(_,v)) -> (k,v))
    
let userTotalMentions: day_edgenums -> day -> reps =
  fun denums day ->
    denums.(day) |> snd |> H.map (fun user (nedges,nusers) -> nedges)

(* TODO add optional parameter to limit Social Capital to mature, older than 5-7 days;
   and replace immature SC with a smoothing default, which is tricky to compute *)
let dayUserReals: user_day_reals -> day_user_reals =
  fun c ->
  let res = Array.init daysN (fun _ -> H.create usersN) in

  H.iter begin fun user days ->
    L.iter (fun (day,x) -> H.replace res.(day) user x) days        
  end c;  
  res
