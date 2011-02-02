(* read rates and typeset a LaTeX table *)
open Common
open Getopt
open TeX

let latex     = ref false
let tableDoc  = ref false
let verbose   = ref false

let specs =
[
  ('t',"tex",   (set latex     true),None);
  ('T',"tdoc",  (set tableDoc  true),None);
  ('v',"verbose",(set verbose  true),None)
]

(* Float.print would do, but it doesn't control for precision *)
let floatPrint oc x = fprintf oc "%5.2f" x
  
let () =
  let args = getOptArgs specs in
  
  let tex = texParams latex tableDoc in
  
  let ratesName =
  match args with
  | x::[] -> x
  | _ -> failwith "texrates [-tT] ratesName"
  in
  
  let suffix,asWhat = match tex with | TeX | DocTeX _ -> ".tex","latex" | _ -> ".txt","text" in
  let replaced,saveBase = String.replace ratesName ".mlb" "" in
  assert replaced;
  let saveName = saveBase^suffix in
  leprintfln "reading rates from %s, writing %s to %s"
    ratesName asWhat saveName;
  
  let rates : rates = loadData ratesName in

  let oc = open_out saveName in
  print_table oc     tex saveBase floatPrint rates; close_out oc;
  if !verbose then print_table stdout tex saveBase floatPrint rates else ()
  