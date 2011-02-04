open Common

type tex = TeX | DocTeX | Plain

let texParams isTeX isDoc =
  let tex =
  match isTeX,isDoc with
  | true,true  -> DocTeX
  | true,false -> TeX
  | _          -> Plain in
  let suffix,asWhat = 
  match tex with 
  | TeX | DocTeX _ -> "tex","latex" 
  | _ -> "txt","text" in
  tex,suffix,asWhat

  
(* Float.print would do, but it doesn't control for precision *)
let floatPrint   oc x = fprintf oc "%5.2f" x
let sciencePrint oc x = fprintf oc "%5.2e" x

(* TODO because of these differently typed normalize functions,
   we cannot unify printAnyTable out of print{Int,Float}Table,
   and consequently have to keep separate print{Int,Float}Table.
   Note, howeverm how printTable is polymorphic, as it doesn't invoke
   any numerically typed function itself.  Generalize by pushing
   notmalize into the top driver, and then printing any tables?  *)

let normalizeIntTable:   int_rates -> rates =
	fun table ->
	L.map begin fun bucket ->
		let total = L.sum bucket |> float in
		L.map (float |- flip (/.) total) bucket
	end table
  

let normalizeFloatTable: rates -> rates =
	fun table ->
	L.map begin fun bucket ->
		let total = L.fsum bucket in
		L.map (flip (/.) total) bucket
	end table

  
let printTable oc tex printOne table caption name =
  let anyTeX,docTeX = 
  match tex with
  | DocTeX -> true,true
  | TeX    -> true,false
  | _      -> false,false
  in

  if docTeX then
    fprintf oc "
\\documentclass{article}
\\begin{document}    
" else ();

  if anyTeX then
    fprintf oc "
\\resizebox{\\linewidth}{!}{
\\begin{tabular}{|cccccccc|}
\\toprule
\\emph{day} & 10 & 100 & 1K & 10K & 100K & 1M & 10M \\\\
\\midrule
" else ();
  
  L.iteri begin fun day rs ->
    fprintf oc "%d" (day+7) ;
    if anyTeX then
      L.print ~first:" & "~sep:" & " ~last:"\\\\\n" printOne oc rs
    else
      L.print ~first:"" ~sep:" " ~last:"\n" printOne oc rs
  end (table |> L.take 34 |> L.drop 7);
  
  if anyTeX then
    fprintf oc "
\\end{tabular}}
\\label{table:%s}
\\caption{\\small %s}
" caption caption else ();

  if docTeX then
    fprintf oc "
\\end{document}    
" else ()


let tables2x2 tableNames =
  match tableNames with
  | t1::t2::t3::rest -> 
  let t4block = 
  match rest with
  | t4::[] ->
   sprintf "\\hfill%%
\\minipage{0.50\\textwidth}
\\input{%s}
\\endminipage
" t4
  | [] -> ""
  | _ -> failwith "table2x2 takes either 3 or 4 names"
  in
  sprintf "
\\begin{table}
\\centering

\\minipage{0.50\\textwidth}
\\input{%s}
\\endminipage\\hfill%%
%%
\\minipage{0.50\\textwidth}
\\input{%s}
\\endminipage

\\bigskip

\\minipage{0.50\\textwidth}
\\input{%s}
\\endminipage%s
\\end{table}
\\FloatBarrier
" t1 t2 t3 t4block
  | _ -> failwith "four_tables needs a list of four strings"


let texDocument s =
  sprintf "
\\documentclass{article}
\\usepackage{booktabs,graphicx}
\\begin{document}
%s
\\end{document}" s


let drop_tex x = dropText ".tex" x

let printMatrix oc doc tableNames =
  let mats = tables2x2 tableNames in
  let s = if doc then texDocument mats else mats in
  String.print oc s
  

let mayPrependPath optPath x = match optPath with
| Some path -> sprintf "%s/%s" path x
| _ -> x


let printShowMatrix matrixDoc ?(verbose=false) outDir ?(inputPath=None) matrixName includeNames =
  let includeNames = L.map (mayPrependPath inputPath) includeNames in
  
  let docKind = if matrixDoc then "document" else "tabular" in
  leprintf "saving %s matrix in %s" docKind matrixName;
  L.print ~first:", including " ~sep:", " ~last:"\n" String.print stderr includeNames;
  
  let pathName = sprintf "%s/%s" outDir matrixName in
  let oc = open_out pathName in
  printMatrix oc matrixDoc includeNames; 
  close_out oc;
  if verbose then 
  	printMatrix stdout matrixDoc includeNames 
  else ()
  
  
let printShowMasterLine ?(verbose=false) outDir ?(inputPath=None) matrixName =
  let pathName = sprintf "%s/line-%s" outDir matrixName in
  let includeName = mayPrependPath inputPath (drop_tex matrixName) in
  let theLine = sprintf "\\input{%s}\n" includeName in
  let oc = open_out pathName in String.print oc theLine; close_out oc;
  if verbose then String.print stdout theLine else ()
  
  
let printShowTable: tex -> ?verbose:bool -> 
  ('a BatInnerIO.output -> 'b -> unit) ->
  'c list list -> string -> ?drop:string option -> string -> unit =
  fun tex ?(verbose=false) printOne table outDir ?(drop=None) tableName ->
    let pathName = sprintf "%s/%s" outDir tableName in
    
    let name = 
    match drop with
    | Some infix -> dropText infix tableName
    | _ -> tableName
    in
    let caption = drop_tex name in
    let oc = open_out pathName in
    printTable oc tex printOne table caption tableName; 
    close_out oc;
    if verbose then 
    	printTable stdout tex printOne table caption tableName 
   else ()
  
  
let printShowTables: tex -> ?verbose:bool -> 
  ('a BatInnerIO.output -> 'b -> unit) ->
  'c list list list -> string -> ?drop:string option -> string list -> unit =
  fun tex ?(verbose=false) printOne tables outDir ?(drop=None) tableNames ->
  L.iter2 begin fun table tableName -> 
    printShowTable tex ~verbose printOne table outDir ~drop tableName
  end tables tableNames


let showDir dir =
  if String.is_empty dir 
    then "locally"
    else let slash = match trailingChar dir with
      | Some '/' -> "" 
      | _ -> "/" in
      sprintf "to %s%s" dir slash
      

let saveBase ?(mark=None) ?(drop=None) suffix inName =      
  let replaced,saveBase = String.replace inName ".mlb" "" in
  assert replaced;
  let saveBase = match drop with 
  | Some drop -> dropText drop saveBase
  | _ -> saveBase in
  let daMark  = match mark with | Some x -> "-"^x | _ -> "" in
  let infiks  = sprintf "%s-%s" daMark saveBase in
  let suffiks = sprintf "%s.%s" infiks suffix in
  infiks, suffiks
  
let listNames saveSuffix prefixes = 
  L.map (flip (^) saveSuffix) prefixes
  
let reportTableNames inName asWhat outDir tableNames =
  leprintf "splitting %s as %s %s, new tables:" inName asWhat (showDir outDir); 
  L.print ~first:"" ~sep:", "~last:"\n" String.print stderr tableNames

let tableFileName optDrop dataFileName =
  dataFileName |> 
  mayDropText optDrop |> dropText ".mlb" |> 
  sprintf "%s.tex"
