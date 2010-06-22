open Batteries_uni
open Printf
module H=Hashtbl

let leprintf   format = eprintf (format ^^ "%!")
let leprintfln format = eprintf (format ^^ "\n%!")

let hash_of_list x = x |> List.enum |> H.of_enum

let showSomeInt x = match x with | Some i -> string_of_int i | _ -> "none"

let hashMergeWith f h1 h2 =
  H.fold (fun k v1 res -> 
    let _ = match H.find_option res k with
    | Some v2 -> H.replace res k (f v1 v2)
    | _ -> H.add res k v1 in
    res) h1 h2
    
let hashMapWith f h1 h2 =
  H.map (fun k v1 ->
    let v2 = H.find h2 k in
    f v1 v2) h1

let hashFirstOption h = h |> H.enum |> Enum.peek

(* unsafe *)
let hashFirst x = x |> hashFirstOption |> Option.get

let enumCatMaybes xs = xs |> Enum.filter Option.is_some |> Enum.map Option.get

let getArgs = Sys.argv |> Array.to_list |> List.tl

let option_of_list x = x |> List.enum |> Option.of_enum