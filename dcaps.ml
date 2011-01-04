open Common
open By_day

type caps            = float list
type day_caps        = caps array
type log_buckets     = (float * int) list
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
  aux 0 under [(under,0)] 
  