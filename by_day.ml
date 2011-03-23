open Common

let daysTotal  = Const.daysTotal
let usersDaily = Const.usersDaily
let repsN      = Const.repsN

let by_day: graph -> days = fun g ->

  (* 35 days, we know -- or have to scan all days *)
  
  let newReps : int -> user_user = fun usersDaily -> H.create usersDaily in
  let res = Array.init daysTotal (fun _ -> (newReps usersDaily, newReps usersDaily)) in

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

let day_re_me: days -> day_re_me =
  fun a ->
  let de = dayEdgenums a in
  array_split de

let numUserEdges: user_nums_pair -> user_ints_enum =
    fun enums -> enums |> fst |> H.enum |> E.map (fun (k,(v,_)) -> (k,v))
    
let numUserUsers: user_nums_pair -> user_ints_enum =
    fun enums -> enums |> fst |> H.enum |> E.map (fun (k,(_,v)) -> (k,v))
    
let userTotalMentions: day_edgenums -> day -> reps =
  fun denums day ->
    denums.(day) |> snd |> H.map (fun user (nedges,nusers) -> nedges)

(* TODO add optional parameter to limit Social Capital to mature, older than 5-7 days;
   and replace immature SC with a smoothing default, which is tricky to compute *)
let dayUserReals: user_day_reals -> day_user_reals =
  fun c ->
  let res = Array.init daysTotal (fun _ -> H.create usersDaily) in

  H.iter begin fun user days ->
    L.iter (fun (day,x) -> H.replace res.(day) user x) days        
  end c;  
  res
