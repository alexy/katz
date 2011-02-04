open Common
open Getopt
open TeX

(* tabulate a sb data as 4 tables *)

let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref false
let matrixDoc' = ref false
let averages'  = ref false
let outDir'    = ref ""
let drop'      = ref "rbucks-aranks-caps-"
let verbose'   = ref false

let specs =
[
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    true), None);
  ('d',"mdoc",      (set matrixDoc' true), None);
  ('a',"averages",  (set averages'  true), None); 
  ('o',"outdir",    None, Some (fun x -> outDir' := x));
  ('x',"drop",      None, Some (fun x -> drop'   := x));
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   averages,   outDir,   drop,   verbose =
      !latex', !tableDoc', !matrix', !matrixDoc', !averages', !outDir', !drop', !verbose' in  	
  
  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  let mark = if averages then "avg" else "med" in
  let drop = if String.is_empty drop then None else Some drop in
  
  let sbName = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texstarbucks [-tTmd] sbName"
  in

 
  let saveInfix, saveSuffix = saveBase ~mark suffix sbName in  

  let prefixes    = ["self";"star";"auds"] in

  let tableNames = listNames saveSuffix prefixes in
  reportTableNames sbName asWhat outDir tableNames;

    
  let sb: day_starbucks = loadData sbName in
  let carver = if averages then fst else snd in
  let triples = carveTL carver (A.to_list sb) in
  let self,star,auds = 
    carveTL fst3 triples, carveTL snd3 triples, carveTL trd3 triples in
  let tables: rates list = [self;star;auds] in
  
  printShowTables tex ~verbose floatPrint tables outDir ~drop tableNames;

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in    
    printShowMatrix matrixDoc ~verbose outDir matrixName includeNames
  end
  else ()