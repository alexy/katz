open Batteries_uni
open Tokyo_graph
open Binary_graph
open Utils 

let () =
  let args = getArgs in
  let (fileName,saveBase,maxElems,progress) = 
        match args with 
          | w::x::y::z::_ -> (w, x,  some_int y, some_int z)
          | w::x::y::_ ->    (w, x,  some_int y, Some 10000)
          | w::x::_ ->       (w, x,  None,       Some 10000)
          | _ -> failwith "need a file name for the cabinet and a base to save"
        in
  let ext = ".mlb" in
  let graphFile = saveBase ^ ext in
  leprintfln ("reading graph from cabinet: %s "
    ^^ "\n  saving graph in %s,"
    ^^ "\n  maxElems: %s, progress: %s")
    fileName graphFile (showSomeInt maxElems) (showSomeInt progress);
  let graph = fetchGraph fileName maxElems progress in
  leprintfln "well, let's save it now, shall we?";
  saveData graph graphFile

