open Common
open By_day

type caps            = float list
type day_caps        = caps array
type log_buckets     = float * (float list)
type day_log_buckets = log_buckets array

let mature_day_caps: int -> float -> ?sort:bool -> user_day_reals -> day_caps =
  fun maturity minimum ?(sort=false) dcaps ->

  let res = Array.create daysN ([]: caps) in

  H.iter begin fun user days ->
    let ordered = L.rev days in
    let day0 = ordered |> L.hd |> fst in
    L.iter begin fun (day,x) -> 
      let c = if (day - day0) >= maturity then x else minimum in
      res.(day) <- c::res.(day)
      end ordered;
  end dcaps;
  if sort 
  then
    A.iteri (fun i e -> res.(i)  <- L.sort e) res
  else ();
  res

(* NB now that we store caps ascending, bucketize1 doesn't work as is,
   can be rewritten to scan from the right though... *)
let bucketize1 a =
  let len = L.length a in
  (* A.sort (fun x y -> compare y x) a; -- we have a sorted list *)
  let desc = L.backwards a in
  let under = E.peek desc |> Option.get |> 
      log10 |> int_of_float |> pred |> float_of_int |> ( ** ) 10. in
  let (res,_,i) = E.fold begin fun (res,bound,i) x ->
    if x >= bound 
    then (res, bound, succ i)
    else (i::res, bound /. 10., succ i)
  end ([], under, 0) desc in
  let res = i::res |> L.map (fun x -> len - x) in
  (under,res)
  
let bucketize2 l =
  let a = A.of_list l in
  let len   = A.length a in
  let iLast = pred len in 
  (* A.sort compare a; -- already sorted ascending *)
  let under = log10 a.(1) |> floor |> ( ** ) 10. in

  let rec aux from bound acc =
    match Proportional.justGreater a ~from bound with
    | Some i when i < iLast -> 
        aux (succ i) (bound*.10.) (i::acc) 
    | _ -> (bound,acc) in
  let (upper,res) = aux 0 under [0] in 
  let res = iLast::res |> 
  (* L.map (fun x -> len - x) -- positions in sorted descending *)
  L.rev 
  in
  (upper,res)
  