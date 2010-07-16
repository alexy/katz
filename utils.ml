open Printf
(* if we open Printf after Batteries, we get leprintf all screwed up! *)
open Batteries_uni
module H=Hashtbl

let leprintf   format = eprintf (format ^^ "%!")
let leprintfln format = eprintf (format ^^ "\n%!")

(* this is slow since it doesn't specify a possibly large initial length
   instead, we can have an optional parameter and first H.create with that,
   and then List.iter ... H.add *)
let hash_of_list x = x |> List.enum |> H.of_enum
let list_of_hash h = h |> H.enum |> List.of_enum

let showSomeInt x = match x with | Some i -> string_of_int i | _ -> "none"

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
