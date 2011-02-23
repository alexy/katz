open Common
open Getopt
open TeX

(* tabulate a sb data as 4 tables *)

let takeDays'  = ref (Some 33)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref false
let matrixDoc' = ref false
let averages'  = ref false
let outDir'    = ref ""
let inputPath' = ref None   (* input path to encode in the matrix' input statements *)
let masterLine'= ref true
let drop'      = ref (Some "sbucks-stars-")
let scientific'= ref true   (* stoggle cientific notation %e vs. %f *)
let verbose'   = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    true), None);
  ('d',"mdoc",      (set matrixDoc' true), None);
  ('a',"averages",  (set averages'  true), None); 
  ('o',"outdir",    None, Some (fun x -> outDir' := x));
  ('i',"inputpath", None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",(set masterLine' (not !masterLine')),None);
  ('x',"drop",      None, Some (fun x -> drop'   := Some x));
  ('X',"nodrop",    (set drop' None),      None);
  ('e',"scientific",(set scientific' (not !scientific')),None);
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   averages =   
      !latex', !tableDoc', !matrix', !matrixDoc', !averages' in	
  
  let outDir,   inputPath,   masterLine,  drop,    scientific,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !scientific', !verbose' in

  let takeDays,   dropDays =
      !takeDays', !dropDays' in
  
  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  let mark = if averages then Some "avg" else Some "med" in
  
  let sbName = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texstarbucks [-tTmd] sbName"
  in

 
  let saveInfix, saveSuffix = saveBase ~mark ~drop suffix sbName in  

  let prefixes    = ["self";"star";"auds"] in

  let tableNames = listNames saveSuffix prefixes in
  reportTableNames sbName asWhat outDir tableNames;

    
  let sb: day_starbucks = loadData sbName in
  let carver = if averages then fst else snd in
  let triples = carveTL carver (A.to_list sb) in
  let self,star,auds = 
    carveTL fst3 triples, carveTL snd3 triples, carveTL trd3 triples in

  let tables: rates list = [self;auds;star] in
  let startRow,tables = dayRanges ~takeDays ~dropDays tables in
  
  let realPrint = if scientific then sciencePrint else floatPrint in
  
  printShowTables tex ~verbose realPrint tables ~startRow outDir tableNames;

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in    
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName includeNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  else ()