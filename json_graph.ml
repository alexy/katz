open Batteries_uni
open Json_io
open Json_type
open Json_type.Browse
(* open Graph *)

module H=Hashtbl

let js = "{\"9\":{\"jovenatheart\":1},\"10\":{\"beverlyyanga\":1},\"31\":{\"mcshellyshell\":1}}"

(* point-free fails here to type-check in json2graph:
  let hash_of_list = List.enum |- H.of_enum
 *)
 
let hash_of_list x = x |> List.enum |> H.of_enum

let json2reps = objekt |- List.hd |- function (x,y) -> (x, int y)

let json2adj = objekt |- List.map (fun (x,y) -> (int_of_string x,json2reps y)) |- hash_of_list

(* point-free couldn't be generalized *)
let json2graph x = x |> List.map (fun (user,s) -> (user, s |> json_of_string |> json2adj)) |> hash_of_list