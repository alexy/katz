open Common

(* normalizes dcaps throughout, saves capitas only, no users *)
let mature_day_caps: int -> float -> ?sort:bool -> user_day_reals -> day_caps =
  fun mindays mincap ?(sort=false) dcaps ->

  let res = Array.create Constants.daysTotal ([]: caps) in

  H.iter begin fun user days ->
    let ordered = L.rev days in
    let day0 = ordered |> L.hd |> fst in
    L.iter begin fun (day,x) -> 
      let c = if (day - day0) >= mindays then x else mincap in
      res.(day) <- c::res.(day)
    end ordered;
  end dcaps;
  if sort then
    A.iteri (fun i e -> res.(i) <- L.sort e) res
  else ();
  res
  

(* normalizes dcaps throughout, preserves by day, saves as (user,cap) list for each day *)
let mature_day_user_caps: int -> float -> ?sort:bool -> user_day_reals -> day_user_caps =
  fun mindays mincap ?(sort=false) dcaps ->

  let res = Array.create Constants.daysTotal ([]: user_caps_list) in

  H.iter begin fun user days ->
    let ordered = L.rev days in
    let day0 = ordered |> L.hd |> fst in
    L.iter begin fun (day,x) -> 
      let c = if (day - day0) >= mindays then x else mincap in
      res.(day) <- (user,c)::res.(day)
    end ordered;
  end dcaps;
  A.map begin fun li ->
  	let a = A.of_list li in
		if sort then
			A.sort compPairAsc2 a
		else ();
		a
	end res
  
  
(* create a real-valued list for users to attach proportionally,
   normalizes just the last cap and returns the last ones only *)
let mature_caps minDays minCap dcaps =
  H.map begin fun user caps ->
    if L.length caps < minDays then minCap
    else L.hd caps |> snd
  end dcaps
  

(* TODO throw exception if  *)
let rec underBound x bound =
  if x <= 0. || bound < x then bound
  else underBound x (bound /. 10.)

(* NB now that we store caps ascending, bucketize1 doesn't work as is,
   can be rewritten to scan from the right though... *)
let bucketize1 a =
  let len = L.length a in
  (* A.sort (fun x y -> compare y x) a; -- we have a sorted list *)
  let desc = L.backwards a in
  let under = E.peek desc |> Option.get |> 
      log10 |> int_of_float |> float_of_int |> ( ** ) 10. in
  let (res,bound,i) = E.fold begin fun (res,bound,i) x ->
    if x >= bound 
    then (res, bound, succ i)
    else
       let res = (bound,i)::res in
       let i' = succ i in
       let x = 
         match E.peek desc with 
         | Some x -> x
         | None   -> L.hd a
       in
       let newBound = underBound x bound in
       (res, newBound, i')
  end ([], under, 0) desc in
  let res = (bound,i)::res |> L.map (fun (r,i) -> (r,len - i)) in
  (under,res)


let rec exceedBound x bound =
  if bound > x then bound
  else exceedBound x (bound*.10.)  
  
let bucketize2 l =
  let a = A.of_list l in
  let len   = A.length a in
  let iLast = pred len in 
  (* A.sort compare a; -- already sorted ascending *)
  let under = log10 a.(0) |> floor |> ( ** ) 10. in
  
  let rec aux from bound acc =
    match Proportional.justGreater a ~from bound with
    | Some i when i < iLast -> 
        let i' = succ i in
        let newBound = exceedBound a.(i') bound in
        aux i' newBound ((bound,i)::acc)
    | _ -> 
      let lastBound = exceedBound a.(iLast) bound in
      (* len to sync with bucketize1, iLast for real last index *)
      (lastBound,len)::acc |> L.rev in
  aux 0 under [] 
  
  
let bucket_lens: day_log_buckets -> day_log_buckets =
  fun bucks -> 
    A.map begin fun day ->
      let start = L.hd day in
      let startList = [start] in
      let prev = snd start in
      L.fold_left begin fun (res,prev) (x,i) -> 
        ((x,i-prev)::res,i)
      end (startList,prev) (L.tl day)
      |> fst
    end bucks
  
  
let dcaps_hash: dcaps -> dcaps_hash * starts_hash =
  fun dcaps ->
    let hcaps = 
    H.map begin fun _ daycaps ->
      L.enum daycaps |> H.of_enum 
    end dcaps in 
    let starts = 
    H.filter_map begin fun _ daycaps ->
      L.backwards daycaps |> E.map fst |> E.peek
    end dcaps in
    hcaps,starts
    

let matureUserDay maturity user day dcapsh =
  match Dreps.getUserDay user day dcapsh with
  | Some c -> 
    let c = begin 
    match maturity with
    | Some (startsh,minDays,minCap) -> 
      let firstDay = startsh --> user in
      if day - firstDay > minDays 
        then c
        else minCap
    | _ -> c
    end in Some c
  | _ -> None