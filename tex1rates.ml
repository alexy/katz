open Common
open Getopt
open TeX

(* tabulate a b2b data as 4 tables *)

let fromArray' = ref false
let takeDays'  = ref (Some 33)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref true
let matrixDoc' = ref false
let summary'   = ref true
let filter1'   = ref true
let showTables'= ref true
let areInts'   = ref false
let normalize' = ref false
let outDir'    = ref ""
let inputPath' = ref None   (* input path to encode in the matrix' input statements *)
let masterLine'= ref true
let drop'      = ref (Some "rbucks-aranks-caps-")
let dropRow'   = ref (Some "srates-")
let scientific'= ref false   (* stoggle cientific notation %e vs. %f *)
let precise'   = ref false
let verbose'   = ref false
let justOne'   = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('a',"array",       (set fromArray'   (not !fromArray')),   None);
  ('t',"tex",         (set latex'       (not !latex')),       None);
  ('T',"tdoc",        (set tableDoc'    (not !tableDoc')),    None);
  ('m',"matrix",      (set matrix'      (not !matrix')),      None);
  (noshort,"nomatrix",(set matrix'      false),               None);
  ('d',"mdoc",        (set matrixDoc'   (not !matrixDoc')),   None);
  ('s',"summary",     (set summary'     (not !summary')),     None);
  (noshort,"filter1", (set filter1'     (not !filter1')),     None);
  ('S',"showTables",  (set showTables'  (not !showTables')),  None);
  (noshort,"notables",(set showTables'  false),               None);
  ('n',"normalize",   (set normalize'   true),                None);
  ('I',"ints",        (set areInts'     (not !areInts')),     None);
  ('o',"outdir",      None, Some (fun x -> outDir'    := x));
  ('i',"inputpath",   None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",  (set masterLine' (not !masterLine')),   None);
  ('x',"drop",        None, Some (fun x -> drop'      := Some x));
  ('X',"nodrop",      (set drop'        None),                None);
  (noshort,"droprow", None, Some (fun x -> dropRow'   := Some x));
  (noshort,"nodroprow",(set dropRow'    None),                None);
  ('e',"scientific",  (set scientific' (not !scientific')),   None);
  (noshort,"precise", (set precise' (not !precise')),         None);
  ('v',"verbose",     (set verbose'     true),                None);
  ('1',"one",         (set justOne'     true),                None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   normalize,   areInts =   
      !latex', !tableDoc', !matrix', !matrixDoc', !normalize', !areInts' in	
  
  let outDir,   inputPath,   masterLine,   drop,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in

  let takeDays,   dropDays,   summary,   showTables,   scientific =
      !takeDays', !dropDays', !summary', !showTables', !scientific' in
      
  let filter1,   dropRow,   precise,   fromArray,   justOne = 
      !filter1', !dropRow', !precise', !fromArray', !justOne' in

  let tex,suffix,asWhat = texParams latex tableDoc in  
  let outDir = if String.is_empty outDir then suffix else outDir in
  
  let dataFileNames,ttOpt = 
  match args with
  | t1::t2::t3::t4::tt::[]  -> [t1;t2;t3;t4],Some tt
  | t1::t2::t3::tt::[]      -> [t1;t2;t3],Some tt
  | t1::[] when justOne     -> [t1],None
  | _ -> failwith "usage: tex4rates [-tdmvL [-i inputPath] [-o outDir] [-x drop]] t1 [t2 t3 [t4] tt]"
  in
    
  let tableNames = L.map (tableFileName suffix drop) dataFileNames in
  reportTableNames "raw world" asWhat outDir tableNames;
  
  let floatPrint = pickFloatPrint scientific precise in
  
  if areInts then 
  begin
    let tables: int_rates list = L.map (loadTable ~fromArray) dataFileNames in
    let startRow,tables = dayRanges ~takeDays ~dropDays tables in
    if normalize then begin
      let normalTables = L.map normalizeIntTable tables in
      if showTables then printShowTables tex ~verbose floatPrint normalTables ~startRow outDir tableNames else ();
      if summary then tableSummaries    tex ~verbose ~outDir floatPrint ~filter1 ~drop:dropRow normalTables tableNames else ()
    end
    else begin
      if showTables then printShowTables tex ~verbose Int.print  tables       ~startRow outDir tableNames else ();
      if summary then intTableSummaries tex ~verbose ~outDir floatPrint ~filter1 ~drop:dropRow tables tableNames else ()
    end
  end
  else begin
    let tables: rates list = L.map (loadTable ~fromArray) dataFileNames in
    let startRow,tables = dayRanges ~takeDays ~dropDays tables in
    if showTables then printShowTables tex ~verbose floatPrint tables ~startRow outDir tableNames else ();
    if summary then tableSummaries tex ~verbose ~outDir floatPrint ~filter1 ~drop:dropRow tables tableNames else ()  
  end;

  if matrix then begin
    let matrixName   = sprintf "4x%d-%s.tex" (L.length tableNames) (Option.get ttOpt) in  
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName tableNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  
  else ()