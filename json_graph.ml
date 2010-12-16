open Common
open Json_io
open Json_type
open Json_type.Browse


let js = "{\"9\":{\"jovenatheart\":1,\"abra\":2},\"10\":{\"beverlyyanga\":1},\"31\":{\"mcshellyshell\":1}}"

(* point-free fails here to type-check in json2graph:
  let hash_of_list = List.enum |- H.of_enum
 *)

let json2reps = objekt |- List.map (fun (x,y) -> (x, int y)) |- hash_of_list

let json2adj = objekt |- List.map (fun (x,y) -> (int_of_string x,json2reps y)) |- hash_of_list

(* point-free couldn't be generalized *)
let json2graph (x: (user * string) list) : graph = x |> List.map (fun (user,s) -> (user, s |> json_of_string |> json2adj)) |> hash_of_list