open Batteries_uni
open Graph
open Binary_graph
open Utils
open Invert
module H=Hashtbl
    

let () =
  let args = getArgs in
  let (fromName,toName) = 
        match args with 
          | x::y::_ -> (x, y)
          | _ -> failwith "need two file names, for the from and to graphs"
        in
  leprintfln ("reading graph from: %s "
    ^^ "\n  saving inverted graph in %s")
    fromName toName;
  let original : graph = loadData fromName in
  let inverted : graph = invert2  original in
  leprintfln "inverted has length %d" (H.length inverted);
  saveData inverted toName
