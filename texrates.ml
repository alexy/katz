(* read rates and typeset a LaTeX table *)
open Common
open Getopt
open TeX

let takeDays'  = ref (Some 34)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let areInts'   = ref false
let normalize' = ref false
let outDir'    = ref ""
let drop'      = ref (Some "rbucks-aranks-caps-")
let verbose'   = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('t',"tex",    (set latex'     true),None);
  ('d',"doc",    (set tableDoc'  true),None);
  ('n',"normalize", (set normalize' true), None);
  ('I',"ints",      (set areInts'   (not !areInts')),None);
  ('o',"outdir", None, Some (fun x -> outDir' := x));
  ('x',"drop",   None, Some (fun x -> drop'   := Some x));
  (noshort,"nodrop", (set drop' None),None);
  ('v',"verbose",(set verbose'  true),None)
]

let () =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   outDir,   drop,   verbose = 
      !latex', !tableDoc', !outDir', !drop', !verbose' in
      
  let takeDays,   dropDays,   areInts,   normalize  =
      !takeDays', !dropDays', !areInts', !normalize' in
  
  let tex,suffix,asWhat = texParams latex tableDoc in
  let outDir = if String.is_empty outDir then suffix else outDir in
    
  let dataFileName =
  match args with
  | x::[] -> x
  | _ -> failwith "texrates [-tdv [-o outdir]] ratesName"
  in
  

  let _,tableName = saveBase ~drop suffix dataFileName in
  let typeShow = if areInts then "integer" else "float" in
  let normalizedShow = if normalize then "normalized " else "" in
  leprintfln "reading %s rates from %s, writing %s%s to %s %s"
    typeShow dataFileName normalizedShow asWhat tableName (showDir outDir);
  
    
  if areInts then 
  begin
    let table: int_rates = loadData dataFileName in
    let startRow,table = dayRange ~takeDays ~dropDays table in
    if normalize then
      let normalTable = normalizeIntTable table in
      printShowTable tex ~verbose floatPrint normalTable ~startRow outDir tableName
    else
      printShowTable tex ~verbose Int.print  table       ~startRow outDir tableName
  end
  else begin
    let table: rates = loadData dataFileName in
    let startRow,table = dayRange ~takeDays ~dropDays table in
    printShowTable tex ~verbose floatPrint table ~startRow outDir tableName
  end
  