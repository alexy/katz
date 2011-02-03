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
  
  let tex = texParams latex tableDoc in  
  
  let b2bName = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols [-tTmd] b2bName"
  in

  let suffix,asWhat = match tex with | TeX | DocTeX _ -> "tex","latex" | _ -> "txt","text" in
  let replaced,saveBase = String.replace b2bName ".mlb" "" in
  assert replaced;
  let normStr = if absNorm then "abs" else "rel" in
  let saveSuffix = sprintf "-%s-%s.%s" normStr saveBase suffix in
  let outDir = if String.is_empty outDir then suffix else outDir in
  
  let roguePrefix = if absNorm then "srel" else "sabs" in
  let prefixes    = ["befo";"self";"aftr";roguePrefix] in
  let dirPrefixes = L.map ((^) (outDir^"/")) prefixes in
  let tableNames  = L.map (flip (^) saveSuffix) dirPrefixes in
  leprintf "splitting %s as %s into " b2bName asWhat; 
  L.print ~first:"" ~sep:", "~last:"\n" String.print stderr tableNames;
    
  let b2bs: day_b2b = loadData b2bName in
  let before,self,after,rogue = 
    Bucket_power.b2b_ratios absNorm b2bs in
  
  let tables: rates list = [before;self;after;rogue] in
  
  (* printFloatTables tex ~verbose tables tableNames; *)
  printShowTables tex ~verbose floatPrint tables tableNames;

  if matrix then begin
    let includeNames = L.map (flip (^) saveBase) prefixes in
    let matrixName = sprintf "%s/4x4-%s-%s.tex" outDir normStr saveBase in
  
    printShowMatrix matrixDoc ~verbose matrixName includeNames
  end
  else ()