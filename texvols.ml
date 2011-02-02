open Common
open Getopt
open TeX

(* tabulate a vols4 data as 4 tables *)

let latex     = ref false
let tableDoc  = ref false
let matrix    = ref false
let matrixDoc = ref false
let verbose   = ref false

let specs =
[
  ('t',"tex",   (set latex     true),None);
  ('T',"tdoc",  (set tableDoc  true),None);
  ('m',"matrix",(set matrix    true),None);
  ('M',"mdoc",  (set matrixDoc true),None);  
  ('v',"verbose",(set verbose  true),None)
]
  

let _ =
  let args = getOptArgs specs in
  
  let tex = texParams latex tableDoc in  
  
  let vols4Name = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols [-tTmM] vols4Name"
  in

  let suffix,asWhat = match tex with | TeX | DocTeX _ -> ".tex","latex" | _ -> ".txt","text" in
  let replaced,saveBase = String.replace vols4Name ".mlb" "" in
  assert replaced;
  let saveSuffix = saveBase^suffix in
  
  let prefixes   = ["re";"ru";"me";"mu"] in
  let tableNames = L.map (flip (^) saveSuffix) prefixes in
  leprintf "splitting %s as %s into " vols4Name asWhat; 
  L.print ~first:"" ~sep:", "~last:"\n" String.print stderr tableNames;
  
  let als_list x = (array_list_split |- fun (a,b) -> A.to_list a, A.to_list b) x in
  
  let vols4: bucket_volumes4 = loadData vols4Name in
  let (re,ru),(me,mu) = array_list_split vols4 |> 
    fun (v,w) -> als_list v, als_list w in
  let tables = [re;ru;me;mu] in
  
  L.iter2 begin fun table tableName -> 
    let oc = open_out tableName in
    print_table oc     tex tableName Int.print table; close_out oc;
    if !verbose then print_table stdout tex tableName Int.print table else ()
  end tables tableNames;
  
  if !matrix then begin
    let matrixName = sprintf "4x4-%s.tex" saveBase in
    
    leprintf "saving matrix in %s" matrixName;
    if !matrixDoc then
      leprintfln ", as document"
    else
      leprintfln " (just tabular)";
    
    let includeNames = L.map (flip (^) saveBase) prefixes in
    let oc = open_out matrixName in
    print_matrix oc !matrixDoc includeNames; close_out oc;
    if !verbose then print_matrix stdout !matrixDoc tableNames else ()
  end
  else ()