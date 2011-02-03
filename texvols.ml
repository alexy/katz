open Common
open Getopt
open TeX

(* tabulate a vols4 data as 4 tables *)

let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref false
let matrixDoc' = ref false
let normalize' = ref false
let outDir'    = ref ""
let verbose'   = ref false

let specs =
[
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    true), None);
  ('d',"mdoc",      (set matrixDoc' true), None);  
  ('n',"normalize", (set normalize' true), None);
  ('o',"outdir",    None, Some (fun x -> outDir' := x));
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   normalize,   outDir,    verbose =
      !latex', !tableDoc', !matrix', !matrixDoc', !normalize', !outDir',  !verbose' in  	
  
  let tex = texParams latex tableDoc in  
  
  let vols4Name = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols [-tTmd] vols4Name"
  in

  let suffix,asWhat = match tex with | TeX | DocTeX _ -> "tex","latex" | _ -> "txt","text" in
  let replaced,saveBase = String.replace vols4Name ".mlb" "" in
  assert replaced;
  let normStr = if normalize then "norm" else "int" in
  let saveInfix = sprintf "-%s-%s" normStr saveBase in
  let saveSuffix = sprintf "%s.%s" saveInfix suffix in
  let outDir = if String.is_empty outDir then suffix else outDir in
  
  let prefixes   = ["re";"ru";"me";"mu"] in
  let dirPrefixes = L.map ((^) (outDir^"/")) prefixes in
  let tableNames = L.map (flip (^) saveSuffix) dirPrefixes in
  leprintf "splitting %s as %s into " vols4Name asWhat; 
  L.print ~first:"" ~sep:", "~last:"\n" String.print stderr tableNames;
  
  let als_list x = (array_list_split |- fun (a,b) -> A.to_list a, A.to_list b) x in
  
  let vols4: bucket_volumes4 = loadData vols4Name in
  let (re,ru),(me,mu) = array_list_split vols4 |> 
    fun (v,w) -> als_list v, als_list w in
  let tables = [re;ru;me;mu] in
  
  (* printIntTables tex ~normalize ~verbose tables tableNames; *)
  
  if normalize then
    let normalTables = L.map normalizeIntTable tables in
    printShowTables tex ~verbose floatPrint normalTables tableNames
  else
    printShowTables tex ~verbose Int.print  tables       tableNames;
    

  if matrix then begin
    let includeNames = L.map (flip (^) saveInfix) prefixes in
    let matrixName = sprintf "%s/4x4-%s-%s.tex" outDir normStr saveBase in
  
    printShowMatrix matrixDoc ~verbose matrixName includeNames
  end
  else ()