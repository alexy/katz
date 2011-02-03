open Common
open Getopt
open TeX

(* tabulate a b2b data as 4 tables *)

let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref false
let matrixDoc' = ref false
let absNorm'   = ref false
let outDir'    = ref ""
let verbose'   = ref false

let specs =
[
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    true), None);
  ('d',"mdoc",      (set matrixDoc' true), None);
  ('a',"absNorm",   (set absNorm'   true), None); 
  ('o',"outdir",    None, Some (fun x -> outDir' := x));
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   absNorm,   outDir,    verbose =
      !latex', !tableDoc', !matrix', !matrixDoc', !absNorm', !outDir',  !verbose' in  	
  
  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  let mark = if absNorm then "abs" else "rel" in
  
  let b2bName = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols [-tTmd] b2bName"
  in


  let saveInfix, saveSuffix = saveBase ~mark suffix b2bName in  
  
  let roguePrefix = if absNorm then "srel" else "sabs" in
  let prefixes    = ["befo";"self";"aftr";roguePrefix] in
  
  let tableNames = listNames saveSuffix prefixes in
  reportTableNames b2bName asWhat outDir tableNames;

    
  let b2bs: day_b2b = loadData b2bName in
  let before,self,after,rogue = 
    Bucket_power.b2b_ratios absNorm b2bs in
  
  let tables: rates list = [before;self;after;rogue] in
  
  printShowTables tex ~verbose floatPrint tables outDir tableNames;

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in  
    printShowMatrix matrixDoc ~verbose outDir matrixName includeNames
  end
  else ()