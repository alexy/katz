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
let inputPath' = ref None   (* input path to encode in the matrix' input statements *)
let masterLine'= ref true
let drop'      = ref (Some "rbucks-aranks-caps-")
let verbose'   = ref false

let specs =
[
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    true), None);
  ('d',"mdoc",      (set matrixDoc' true), None);  
  ('n',"normalize", (set normalize' true), None);
  ('o',"outdir",    None, Some (fun x -> outDir' := x));
  ('i',"inputpath", None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",(set masterLine' (not !masterLine')),None);
  ('x',"drop",      None, Some (fun x -> drop'   := Some x));
  ('X',"nodrop",    (set drop'      None), None);
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   normalize =   
      !latex', !tableDoc', !matrix', !matrixDoc', !normalize' in	
  
  let outDir,   inputPath,   masterLine,  drop,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in
  
  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  let mark = if normalize then Some "norm" else Some "int" in
  
  let vols4Name = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols [-tTmd] vols4Name"
  in
  

  let saveInfix, saveSuffix = saveBase ~mark ~drop suffix vols4Name in  
  
  let prefixes   = ["re";"ru";"me";"mu"] in
  
  let tableNames = listNames saveSuffix prefixes in
  reportTableNames vols4Name asWhat outDir tableNames;
  
  
  let vols4: bucket_volumes4 = loadData vols4Name in
  
  let als_list x = (array_list_split |- fun (a,b) -> A.to_list a, A.to_list b) x in
  
  let (re,ru),(me,mu) = array_list_split vols4 |> 
    fun (v,w) -> als_list v, als_list w in
  let tables = [re;ru;me;mu] in
  
  
  if normalize then
    let normalTables = L.map normalizeIntTable tables in
    printShowTables tex ~verbose floatPrint normalTables outDir tableNames
  else
    printShowTables tex ~verbose Int.print  tables       outDir tableNames;
    

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in  
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName includeNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  else ()