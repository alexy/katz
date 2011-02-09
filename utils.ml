open Printf
(* if we open Printf after Batteries, we get leprintf all screwed up! *)
open Batteries_uni
open H
open H.Infix
open Getopt

let leprintf   format = eprintf (format ^^ "%!")
let leprintfln format = eprintf (format ^^ "\n%!")
let leprintfLn        = eprintf "\n%!"

(* this is slow since it doesn't specify a possibly large initial length
   instead, we can have an optional parameter and first H.create with that,
   and then List.iter ... H.add *)
let hash_of_list x = x |> List.enum |> H.of_enum
let list_of_hash h = h |> H.enum |> List.of_enum

let hashList = hash_of_list
let listHash = list_of_hash

let array_of_hash h = H.enum h |> A.of_enum
let arrayHash = array_of_hash

let showSomeInt x = match x with | Some i -> string_of_int i | _ -> "none"

let hashInc h k =
  let v = H.find_default h k 0 in
  H.replace h k (succ v)

let hashAdd h k n =
  let v = H.find_default h k 0 in
  H.replace h k (v+n)
  
let hashFindsert h k default =
  try 
    H.find h k
  with Not_found ->
    H.add h k default;
    H.find h k

(* updates h1! *)
let hashMergeWith f h1 h2 =
  H.fold (fun k v2 res -> 
    let _ = match H.find_option res k with
    | Some v1 -> H.replace res k (f v1 v2)
    | _ -> H.add res k v2 in
    res) h2 h1

(* updates h1! no pure pretenses, no carrying res around *)
let hashMergeWithImp f h1 h2 =
  H.iter (fun k v2 -> 
    match H.find_option h1 k with
    | Some v1 -> H.replace h1 k (f v1 v2)
    | _ -> H.add h1 k v2) h2

let hashMergeWithDefImp f def h1 h2 =
  H.iter (fun k v2 -> 
    match H.find_option h1 k with
    | Some v1 -> H.replace h1 k (f v1 v2)
    | _ -> H.add h1 k (f def v2)) h2
    
let hashMapWith f h1 h2 =
  H.map (fun k v1 ->
    let v2 = H.find h2 k in
    f k v1 v2) h1

(* updates the first map h1! *)
let hashUpdateWithImp f h1 h2 =
  H.iter (fun k v2 ->
    let v1 = H.find h1 k in
    let v = f k v1 v2 in
    H.replace h1 k v) h2

let hashFirstOption h = h |> H.enum |> Enum.peek

(* unsafe *)
let hashFirst x = x |> hashFirstOption |> Option.get

let enumCatMaybes xs = xs |> Enum.filter Option.is_some |> Enum.map Option.get

let getArgs = Sys.argv |> Array.to_list |> List.tl

let option_of_list x = x |> List.enum |> Option.of_enum

let trace_nan msg v = let what = classify_float v in 
	match what with
		| FP_nan -> failwith ("nan: "^msg)
		| FP_infinite -> failwith ("inf: "^msg)
		| _ -> v
	
(* Sys.time gives CPU time *)

type timings = float list

let getTiming msg =
  let t = Sys.time () in
  match msg with
    | Some s -> leprintfln "%s%f" s t; t
    | _ -> t

let show_float_list_meat l =
  let l's = List.map string_of_float l in
  (String.concat ";" l's)
  
let show_float_list l =
  let meat = show_float_list_meat l in
  sprintf "[%s]" meat

let some_int si = Some (int_of_string si)

(* what about using fold_right without revs? *)
let unzip : ('a * 'b) list -> ('a list * 'b list) = fun l ->
  let (xs,ys) = List.fold_left (fun (xs,ys) (x,y) -> (x::xs,y::ys)) ([],[]) l in
  (List.rev xs,List.rev ys)

 (* TODO parameterize 0 and + 
    handle out of bounds from or upto
    e.g. use actuals
  *)
 
 let sum_range ?from ?upto a =
 let from' = match from with
 | Some n -> n
 | _ -> 0 in
 let upto' = match upto with
 | Some n -> n
 | _ -> A.length a - 1 in
 E.fold begin fun res i ->
   res + a.(i) 
 end 0 (E.range from' ~until:upto')

(* thelema *)
let array_split a = 
  let len = A.length a in
  Array.init len (Array.get a |- fst), 
  Array.init len (Array.get a |- snd)

let fst3 (x,_,_) = x
let snd3 (_,x,_) = x
let trd3 (_,_,x) = x

let fst4 (x,_,_,_) = x
let snd4 (_,x,_,_) = x
let trd4 (_,_,x,_) = x
let frh4 (_,_,_,x) = x

let array_split3 a = 
  let len = A.length a in
  Array.init len (Array.get a |- fst3), 
  Array.init len (Array.get a |- snd3),
  Array.init len (Array.get a |- trd3)
  
let list_of_array a =
  A.enum a |> List.of_enum
  
let array_last a =
  a.(A.length a - 1)
  (* A.length a |> pred |> A.get a
     a |> A.length |> pred |> A.get a, or
     A.backwards |> Enum.peek |> Option.get *)

  
(* let safeDivide x y = if y = 0. then x else x /. y *)
let safeDivide x y = let res = x /. y in
	match classify_float res with
		| FP_nan | FP_infinite -> 0. (* or x? *)
		| _ -> res

(* hashMergeWithImp changes the first hashtbl given to it with the second 
   we have to add x as a point for OCaml compiler to see these as functions *)
let addMaps x     = hashMergeWithImp (+) x
(* this was a cause of a subtle bug where in hashMergeWithImp 
   we added positive balance for yinteo and geokotophia *)
let subtractMaps x = hashMergeWithDefImp (-) 0 x

let power10 times = E.fold ( * ) 1 (E.repeat ~times 10)
(* thelema -- fails for times = 0:
   E.repeat ~times 10 |> E.reduce ( * ) 
  
   OCaml doesn't take scientific notation for integers:
   ("1e" ^ string_of_int times) |> float_of_string |> int_of_float  
 *)

let schwartzSortIntHashDesc: ('a,int) H.t -> ('a * int) array =
  fun h ->
  let a = array_of_hash h in
  A.sort begin fun (_,x) (_,y) -> compare y x end a;
  a

let getOptArgs specs =
  let restArgsE = E.empty () in
  let pushArg a = E.push restArgsE a in
  parse_cmdline specs pushArg;
  L.of_enum restArgsE |> L.rev

let show_equals m n =
  let eqsign = if m = n then "=" else "/=" in
  sprintf "%d %s %d" m eqsign n
  
let hash_split h =
  H.map (fun _ xy -> fst xy) h,
  H.map (fun _ xy -> snd xy) h
  
let array_hash_split a = A.map hash_split a |> array_split
let array_list_split a = A.map L.split a |> array_split

let may_normalize norm x = 
  match norm with
  | Some y when y <> 0. -> x /. y
  | _ -> x

let list_norm norm l =
  let x = match l with
  | _::_ -> L.sum l
  | _ -> 0 in
  (float x) /. norm
  
(* carve a given position from a tuple list list *)
let carveTL (* : ('a tuple4 -> 'a) -> float4 list list -> rates *) =
  fun carveOne tull -> L.map (L.map carveOne) tull


let trailingChar s =
  String.backwards s |> E.get
  
let dropText sub str  =
  String.replace ~str ~sub ~by:"" |> snd
  
let mayDropText optSub str =
  match optSub with
  | Some sub -> dropText sub str
  | _ -> str
  
let mayApply f opt = 
  match opt with
  | Some x -> f x
  | _ -> identity
  
let listRange ?(take=None) ?(drop=None) x =
  (mayApply L.take take |- mayApply L.drop drop) x

(* NB: throws exception on []! *)
let listMax2: ('a * float) list -> 'a * float =
  fun l2 ->
  L.fold_left begin fun ((amax,xmax) as curmax) ((a,x) as ax) ->
    if x > xmax then ax else curmax
  end (L.hd l2) (L.tl l2)
  

let itTurnsOut prob =
  Random.float 1.0 < prob
  
let enumNth e n =
  E.drop n e; E.get e
  
let safeDivide3 (x,y,z) (x',y',z') =
  let a = safeDivide x x' in
  let b = safeDivide y y' in
  let c = safeDivide z z' in
  (a,b,c)

let emptyHash () =
  H.create 0
  
let randomElementBut0th a =
  let n = Random.int (A.length a - 1) in
  a.(n+1)
  
let hash_map2 f h1 h2 =
  H.map begin fun k v1 ->
    let v2 = h2 --> k in
    f k v1 v2
  end