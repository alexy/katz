open Common
open Getopt
open TeX

(* tabulate a vols4 data as 4 tables *)

let takeDays'    = ref (Some 34)
let dropDays'    = ref (Some 7)
let latex'       = ref false
let tableDoc'    = ref false
let matrix'      = ref true
let matrixDoc'   = ref false
let summary'     = ref true
let showTables'  = ref true
let normalize'   = ref false
let outDir'      = ref ""
let inputPath'   = ref None   (* input path to encode in the matrix' input statements *)
let masterLine'  = ref true
let drop'        = ref (Some "rbucks-aranks-caps-")
let scientific'  = ref false   (* stoggle cientific notation %e vs. %f *)
let verbose'     = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('t',"tex",         (set latex'       (not !latex')),       None);
  ('T',"tdoc",        (set tableDoc'    (not !tableDoc')),    None);
  ('m',"matrix",      (set matrix'      (not !matrix')),      None);
  (noshort,"nomatrix",(set matrix'      false),               None);
  ('d',"mdoc",        (set matrixDoc'   (not !matrixDoc')),   None);
  ('s',"summary",     (set summary'     (not !summary')),     None);
  ('S',"showTables",  (set showTables'  (not !showTables')),  None);
  (noshort,"notables",(set showTables'  false),               None);
  ('n',"normalize",   (set normalize' (not !normalize')), None);
  ('o',"outdir",      None, Some (fun x -> outDir' := x));
  ('i',"inputpath",   None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",  (set masterLine' (not !masterLine')),None);
  ('x',"drop",        None, Some (fun x -> drop'   := Some x));
  ('X',"nodrop",      (set drop'        None), None);
  ('e',"scientific",  (set scientific' (not !scientific')),   None);
  ('v',"verbose",     (set verbose'     (not !verbose')),     None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   normalize =   
      !latex', !tableDoc', !matrix', !matrixDoc', !normalize' in	
  
  let outDir,   inputPath,   masterLine,  drop,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in
      
  let takeDays,   dropDays,   summary,   showTables,   scientific =
      !takeDays', !dropDays', !summary', !showTables', !scientific' in
  
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
  
  
  let startRow,tables = dayRanges ~takeDays ~dropDays tables in
  let printFloat = if scientific then sciencePrint else floatPrint in
  if normalize then begin
    let normalTables = L.map normalizeIntTable tables in
    if showTables then printShowTables tex ~verbose printFloat normalTables ~startRow outDir tableNames else ();
    if summary then tableSummaries tex ~verbose ~outDir printFloat normalTables tableNames else ()
  end
  else begin
    if showTables then printShowTables tex ~verbose Int.print  tables       ~startRow outDir tableNames else ();
    if summary then intTableSummaries tex ~verbose ~outDir printFloat tables tableNames else ()
  end;

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in  
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName includeNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  else ()