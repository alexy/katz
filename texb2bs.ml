open Common
open Getopt
open TeX

(* tabulate a b2b data as 4 tables *)

let takeDays'  = ref (Some 33)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref false
let matrixDoc' = ref false
let absNorm'   = ref false
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
  ('m',"matrix",    (set matrix'    true), None);
  ('d',"mdoc",      (set matrixDoc' true), None);
  ('a',"absNorm",   (set absNorm'   true), None); 
  ('o',"outdir",    None, Some (fun x -> outDir'    := x));
  ('i',"inputpath", None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",(set masterLine' (not !masterLine')),None);
  ('x',"drop",      None, Some (fun x -> drop'      := Some x));
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   absNorm =   
      !latex', !tableDoc', !matrix', !matrixDoc', !absNorm' in	
  
  let outDir,   inputPath,   masterLine,  drop,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in

  let takeDays,   dropDays =
      !takeDays', !dropDays' in
          
  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  let mark = if absNorm then Some "abs" else Some "rel" in
  
  let b2bName = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols [-tTmd] b2bName"
  in


  let saveInfix, saveSuffix = saveBase ~mark ~drop suffix b2bName in  
  
  let roguePrefix = if absNorm then "srel" else "sabs" in
  let prefixes    = ["befr";"self";"aftr";roguePrefix] in
  
  let tableNames = listNames saveSuffix prefixes in
  reportTableNames b2bName asWhat outDir tableNames;

    
  let b2bs: day_b2b = loadData b2bName in
  let before,self,after,rogue = 
    Bucket_power.b2b_ratios absNorm b2bs in
  
  let tables: rates list = [before;self;after;rogue] in
  let startRow,tables = dayRanges ~takeDays ~dropDays tables in
  
  (* ~drop unnecessary as we do it right in saveInfix! *)
  printShowTables tex ~verbose floatPrint tables ~startRow outDir tableNames;

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in  
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName includeNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  
  else ()