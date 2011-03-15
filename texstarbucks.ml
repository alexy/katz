open Common
open Getopt
open TeX

(* tabulate a sb data as 4 tables *)

let takeDays'  = ref (Some 33)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let matrix'    = ref true
let matrixDoc' = ref false
let summary'   = ref true
let showTables'= ref true
let averages'  = ref false
let outDir'    = ref ""
let inputPath' = ref None   (* input path to encode in the matrix' input statements *)
let masterLine'= ref true
let drop'      = ref (Some "sbucks-stars-")
let scientific'= ref true   (* stoggle cientific notation %e vs. %f *)
let precise'   = ref false
let verbose'   = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('t',"tex",       (set latex'     true), None);
  ('T',"tdoc",      (set tableDoc'  true), None);
  ('m',"matrix",    (set matrix'    (not !matrix')), None);
  (noshort,"nomatrix",(set matrix'      false),               None);
  ('d',"mdoc",      (set matrixDoc' true), None);
  ('s',"summary",   (set summary'     (not !summary')),     None);
  ('S',"showTables",(set showTables'  (not !showTables')),  None);
  ('a',"averages",  (set averages'  true), None); 
  ('o',"outdir",    None, Some (fun x -> outDir' := x));
  ('i',"inputpath", None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",(set masterLine' (not !masterLine')),None);
  ('x',"drop",      None, Some (fun x -> drop'   := Some x));
  ('X',"nodrop",    (set drop' None),      None);
  ('e',"scientific",(set scientific' (not !scientific')),None);
  (noshort,"precise", (set precise' (not !precise')), None);
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc,   averages =   
      !latex', !tableDoc', !matrix', !matrixDoc', !averages' in	
  
  let outDir,   inputPath,   masterLine,  drop,    verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in

  let takeDays,   dropDays,   scientific,   precise =
      !takeDays', !dropDays', !scientific', !precise' in
      
  let summary,   showTables =
      !summary', !showTables' in
  
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
  
  let floatPrint = pickFloatPrint scientific precise in
  
  if showTables then printShowTables tex ~verbose floatPrint tables ~startRow outDir tableNames else ();
	if summary then tableSummaries tex ~verbose ~outDir floatPrint tables tableNames else ();

  if matrix then begin
    let includeNames = listNames saveInfix prefixes in
    let matrixName   = sprintf "4x4%s" saveSuffix in    
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName includeNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  else ()