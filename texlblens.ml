open Common
open Getopt
open TeX
(* open BatIO -- to_string *)
let to_string = BatIO.to_string
 
let takeDays'  = ref (Some 34)
let dropDays'  = ref (Some 7)
let latex'     = ref false
let tableDoc'  = ref false
let normalize' = ref false
let outDir'    = ref ""
let drop'      = ref (Some "jcaps")
let scientific'= ref true   (* stoggle cientific notation %e vs. %f *)
let mark'      = ref None
let verbose'   = ref false

let specs =
[
  (noshort,"takedays",None,Some (fun x -> takeDays' := Some (int_of_string x)));
  (noshort,"notakedays",(set takeDays' None),None);
  (noshort,"dropdays",None,Some (fun x -> dropDays' := Some (int_of_string x)));
  (noshort,"nodropdays",(set dropDays' None),None);
  ('t',"tex",    (set latex'    true),None);
  ('d',"doc",    (set tableDoc' true),None);
  ('n',"normalize", (set normalize' true), None);
  ('o',"outdir", None, Some (fun x -> outDir' := x));
  ('x',"drop",   None, Some (fun x -> drop'   := Some x));
  (noshort,"nodrop", (set drop' None),None);
  ('e',"scientific",(set scientific' (not !scientific')),None);
  ('m',"mark",None,Some (fun x -> mark' := Some x));
  (noshort,"nomark",(set mark' None),None);
  ('v',"verbose",(set verbose'  true),None)
]


(* can go up to teX *)
let fcolStr x = 
  match x with
  | x when x > 1e-4 -> (Float.print |> to_string) x
  | _ -> sprintf "%1.0e" x
 
 
let printLbLens oc tex ?(normalize=false) ?(scientific=true) table ?(startRow=1) scols caption name =
  preamble oc tex;
  
  tableHead oc tex "day" scols;

  let first,sep,last = rowOrnaments tex in
  
  L.iteri begin fun row lbs ->
    let norm = L.map snd lbs |> L.sum |> float in
    
    let hlb = 
      lbs |> L.map begin fun (x,y) -> 
        let k = fcolStr x in
        let v = if normalize then 
          let fPrint = if scientific then sciencePrint else floatPrint in
          (fPrint |> to_string) (float y /. norm)
        else (Int.print |> to_string) y in
        k,v
      end |> L.enum |> H.of_enum in
    
    let cells = scols |> L.map begin fun col ->
      H.find_default hlb col "\\space"
    end in

    Int.print oc (row+startRow);
    L.print ~first ~sep ~last String.print oc cells;

  end table;
    
  tableTail oc tex name caption;
  epilogue oc tex
  

let printShowLbLens tex ?(verbose=false) ?(normalize=false) ?(scientific=true) table ?(startRow=1) 
  cols outDir ?(drop=None) tableName =
  
  let pathName = sprintf "%s/%s" outDir tableName in
  let name = 
    match drop with
    | Some infix -> dropText infix tableName
    | _ -> tableName
  in
  let caption = drop_tex name in
  let oc = open_out pathName in

  printLbLens oc tex ~normalize ~scientific table ~startRow cols caption caption; close_out oc;
  if verbose then
    printLbLens stdout tex ~normalize ~scientific table ~startRow cols caption caption
  else ()
  

let () =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   outDir,   drop,   verbose = 
      !latex', !tableDoc', !outDir', !drop', !verbose' in
      
  let normalize,   scientific,   takeDays,   dropDays,   mark =
      !normalize', !scientific', !takeDays', !dropDays', !mark' in
      
  let tex,suffix,asWhat = texParams latex tableDoc in
  let outDir = if String.is_empty outDir then suffix else outDir in
  let mark = match mark with 
  | Some x as sm -> sm 
  | _ when scientific -> Some "e" 
  | _ -> Some "f" in
  let replace = if normalize then Some "norm" else Some "int" in
  (* standard mark is prepended before lelb, as in f-lelb-norm-dreps;
     but we want infix, as in lelb-f-norm *)
  
  let dataFileName =
  match args with
  | x::[] -> x
  | _ -> failwith "usage: me datafile"
  in
  

  let _,tableName = saveBase ~mark ~drop ~replace ~dash:false suffix dataFileName in
  let normalizedShow = if normalize then "normalized " else "" in
  leprintfln "reading lblens from %s, writing %s%s to %s %s"
    dataFileName normalizedShow asWhat tableName (showDir outDir);
  
  
  let lblens: day_log_buckets = loadData dataFileName in
  let startRow,table = dayRange ~takeDays ~dropDays (A.to_list lblens) in
  
  let h = H.create 10 in 
  L .iter begin fun lbs ->
    L.iter begin fun (x,_) ->
      let k = fcolStr x in
      H.replace h k x
    end lbs
  end table;

  
  let scols = H.enum h |> L.of_enum |> L.sort ~cmp:(fun (_,x) (_,y) -> compare y x) |> L.map fst in
   
  printShowLbLens tex ~verbose ~normalize ~scientific table ~startRow scols outDir ~drop tableName