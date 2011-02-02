open Common

type tex = TeX | DocTeX | Plain

let texParams tex doc =
  match tex,doc with
  | true,true  -> DocTeX
  | true,false -> TeX
  | _          -> Plain

  
(* Float.print would do, but it doesn't control for precision *)
let floatPrint oc x = fprintf oc "%5.2f" x


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

  
let printTable oc tex name printOne table =
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
\\caption{%s}
" name name else ();

  if docTeX then
    fprintf oc "
\\end{document}    
" else ()


(* let print_table oc tex name printOne elems =
  let table_string = 
    sprint_table tex name printOne elems in
  String.print oc table_string *)


let printIntTable: 'a BatInnerIO.output -> tex -> ?normalize:bool ->
  'c list list -> string -> unit =
  fun oc tex ?(normalize=false) table name ->
	if normalize then
		let ft = normalizeIntTable table in
		printTable oc	tex name floatPrint ft		
	else 
		printTable oc tex name Int.print table


let printFloatTable: 'a BatInnerIO.output -> tex -> ?normalize:bool ->
  'c list list -> string -> unit =
  fun oc tex ?(normalize=false) table name ->
	let ft = if normalize then normalizeFloatTable table else table in
	printTable oc	tex name floatPrint ft		


let tables2x2 tableNames =
  match tableNames with
  | t1::t2::t3::t4::[] ->
  sprintf "
\\begin{document}

\\begin{table}
\\centering

\\minipage{0.50\\textwidth}
\\include{%s}
\\endminipage\\hfill%%
%%
\\minipage{0.50\\textwidth}
\\include{%s}
\\endminipage

\\bigskip

\\minipage{0.50\\textwidth}
\\include{%s}
\\endminipage\\hfill%%
%%
\\minipage{0.50\\textwidth}
\\include{%s}
\\endminipage

\\end{table}" t1 t2 t3 t4
  | _ -> failwith "four_tables needs a list of four strings"


let texDocument s =
  sprintf "
\\documentclass{article}
\\usepackage{booktabs,graphicx}
%s
\\end{document}" s


let printMatrix oc doc tableNames =
  let mats = tables2x2 tableNames in
  let s = if doc then texDocument mats else mats in
  String.print oc s
  

let printShowMatrix matrixDoc ?(verbose=false) matrixName includeNames =
  let docKind = if matrixDoc then "document" else "tabular" in
  leprintf "saving %s matrix in %s" docKind matrixName;
  L.print ~first:", including " ~sep:", " ~last:"\n" String.print stderr includeNames;
  
  let oc = open_out matrixName in
  printMatrix oc matrixDoc includeNames; 
  close_out oc;
  if verbose then 
  	printMatrix stdout matrixDoc includeNames 
  else ()
  

let printIntTables: tex -> ?normalize:bool -> ?verbose:bool ->
  int list list list -> string list -> unit =
  fun tex ?(normalize=false) ?(verbose=false) tables tableNames ->
  L.iter2 begin fun table tableName -> 
    let oc = open_out tableName in
    printIntTable oc tex ~normalize table tableName; 
    close_out oc;
    if verbose then 
    	printIntTable stdout tex ~normalize table tableName 
    else ()
  end tables tableNames
  

let printFloatTables: tex -> ?normalize:bool -> ?verbose:bool ->
  float list list list -> string list -> unit =
  fun tex ?(normalize=false) ?(verbose=false) tables tableNames ->
  L.iter2 begin fun table tableName -> 
    let oc = open_out tableName in
    printFloatTable oc tex ~normalize table tableName; 
    close_out oc;
    if verbose then 
    	printFloatTable stdout tex ~normalize table tableName 
    else ()
  end tables tableNames