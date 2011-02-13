open Common
open Getopt
open TeX

(* tabulate a b2b data as 4 tables *)

let takeDays'  = ref (Some 34)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref true
let matrixDoc' = ref false
let areInts'   = ref false
let normalize' = ref false
let outDir'    = ref ""
let inputPath' = ref None   (* input path to encode in the matrix' input statements *)
let masterLine'= ref true
let drop'      = ref (Some "rbucks-aranks-caps-")
let verbose'   = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    !matrix'), None);
  ('d',"mdoc",      (set matrixDoc' true), None);
  ('n',"normalize", (set normalize' true), None);
  ('I',"ints",      (set areInts'   (not !areInts')),None);
  ('o',"outdir",    None, Some (fun x -> outDir'    := x));
  ('i',"inputpath", None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",(set masterLine' (not !masterLine')),None);
  ('x',"drop",      None, Some (fun x -> drop'      := Some x));
  ('X',"nodrop",    (set drop'      None), None);
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   normalize,   areInts =   
      !latex', !tableDoc', !matrix', !matrixDoc', !normalize', !areInts' in	
  
  let outDir,   inputPath,   masterLine,   drop,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in

  let takeDays,   dropDays =
      !takeDays', !dropDays' in
          
  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  
  let dataFileNames,tt = 
  match args with
  | t1::t2::t3::t4::tt::[] -> [t1;t2;t3;t4],tt
  | t1::t2::t3::tt::[]     -> [t1;t2;t3],tt  
  | _ -> failwith "usage: tex4rates [-tdmvL [-i inputPath] [-o outDir] [-x drop]] t1 t2 t3 [t4] tt"
  in

    
  let tableNames = L.map (tableFileName drop) dataFileNames in
  reportTableNames "raw world" asWhat outDir tableNames;
  
  if areInts then 
  begin
    let tables: int_rates list = L.map loadData dataFileNames in
    let startRow,tables = dayRanges ~takeDays ~dropDays tables in
    if normalize then
      let normalTables = L.map normalizeIntTable tables in
      printShowTables tex ~verbose floatPrint normalTables ~startRow outDir tableNames
    else
      printShowTables tex ~verbose Int.print  tables       ~startRow outDir tableNames
  end
  else begin
    let tables: rates list = L.map loadData dataFileNames in
    let startRow,tables = dayRanges ~takeDays ~dropDays tables in
    printShowTables tex ~verbose floatPrint tables ~startRow outDir tableNames
  end;

  if matrix then begin
    let matrixName   = sprintf "4x%d-%s.tex" (L.length tableNames) tt in  
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName tableNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  
  else ()