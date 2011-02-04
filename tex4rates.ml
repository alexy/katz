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
  ('o',"outdir",    None, Some (fun x -> outDir'    := x));
  ('i',"inputpath", None, Some (fun x -> inputPath' := Some x));
  ('L',"masterline",(set masterLine' (not !masterLine')),None);
  ('x',"drop",      None, Some (fun x -> drop'      := Some x));
  ('X',"nodrop",    (set drop'      None), None);
  ('v',"verbose",   (set verbose'   true), None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   matrix,   matrixDoc =   
      !latex', !tableDoc', !matrix', !matrixDoc' in	
  
  let outDir,   inputPath,   masterLine,   drop,   verbose =
      !outDir', !inputPath', !masterLine', !drop', !verbose' in
        
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
  
  let tables: rates list = L.map loadData dataFileNames in
  
  printShowTables tex ~verbose floatPrint tables outDir tableNames;

  if matrix then begin
    let matrixName   = sprintf "4x4-%s.tex" tt in  
    printShowMatrix matrixDoc ~verbose outDir ~inputPath matrixName tableNames;
    
    if masterLine then
      printShowMasterLine ~verbose outDir ~inputPath matrixName
    else ()
  end
  
  else ()