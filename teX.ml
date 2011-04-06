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

let fileSuffix ?(dot=false) tex =
  let s = match tex with
  | TeX | DocTeX -> "tex"
  | _ -> "txt" in
  if dot then "."^s else s
  
(* Float.print would do, but it doesn't control for precision *)

let floatPrint          oc x = fprintf oc "%6.2f" x
let sciencePrint        oc x = fprintf oc "%6.2e" x
let roundedPrint        oc x = fprintf oc "%6.0f" x
let preciseFloatPrint   oc x = fprintf oc "%19.15f" x
let preciseSciencePrint oc x = fprintf oc "%23.15e" x

let pickFloatPrint scientific precise =
  match scientific,precise with
  | false,false -> floatPrint
  | false,true  -> preciseFloatPrint
  | true,false  -> sciencePrint
  | true,true   -> preciseSciencePrint
  

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


let preamble oc tex =
  match tex with 
  | DocTeX ->
    fprintf oc "
\\documentclass{article}
\\begin{document}"    
  | _ -> ()
  

let epilogue oc tex =
  match tex with
  | DocTeX ->
    fprintf oc "
\\end{document}    
" 
  | _ -> ()


let tableHead oc tex rowName cols =
  match tex with
  | TeX | DocTeX ->
    let cs = String.repeat "c" (L.length cols + 1) in
    let colstr = L.sprint ~first:" & " ~sep:" & " ~last:"" String.print cols in
    fprintf oc "
\\resizebox{\\linewidth}{!}{
\\begin{tabular}{|%s|}
\\toprule
\\emph{%s}%s\\\\
\\midrule
" cs rowName colstr
  | _ -> ()


let tableTail oc tex label caption =
  match tex with
  | TeX | DocTeX ->   
    fprintf oc "
\\bottomrule
\\end{tabular}}
\\caption{\\small %s}
\\label{table:%s}
" caption label
  | _ -> ()

  
let rowOrnaments tex =
  match tex with
  | TeX | DocTeX -> " & "," & ","\\\\\n"
  | _ ->            "",   " ",  "\n"
  
  
(* TODO rename to printDayBucketTable 
   since colNames and table droptake hardcoded *)
    
let printTable oc tex printOne table ?(startRow=1) caption name =
  preamble oc tex;

  let colNames = ["10";"100";"1K";"10K";"100K";"1M";"10M"] in
  tableHead oc tex "day" colNames;

  let first,sep,last = rowOrnaments tex in
  
  L.iteri begin fun row rs ->
    Int.print oc (row+startRow);
    L.print ~first ~sep ~last printOne oc rs
  end table;
  
  tableTail oc tex name caption;
  epilogue oc tex


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
  'c list list -> ?startRow:int ->
  string -> ?drop:string option -> string -> unit =
  fun tex ?(verbose=false) printOne table ?(startRow=1) 
      outDir ?(drop=None) tableName ->
    let pathName = sprintf "%s/%s" outDir tableName in
    
    let name = 
    match drop with
    | Some infix -> dropText infix tableName
    | _ -> tableName
    in
    let caption = drop_tex name in
    let oc = open_out pathName in
    printTable oc tex printOne table ~startRow caption caption; 
    close_out oc;
    if verbose then 
    	printTable stdout tex printOne table  ~startRow caption caption 
   else ()
  
  
let printShowTables: tex -> ?verbose:bool -> 
  ('a BatInnerIO.output -> 'b -> unit) ->
  'c list list list -> ?startRow:int ->
  string -> ?drop:string option -> string list -> unit =
  fun tex ?(verbose=false) printOne tables ?(startRow=1) 
      outDir ?(drop=None) tableNames ->
  L.iter2 begin fun table tableName -> 
    printShowTable tex ~verbose printOne table ~startRow outDir ~drop tableName
  end tables tableNames


let showDir dir =
  if String.is_empty dir 
    then "locally"
    else let slash = match trailingChar dir with
      | Some '/' -> "" 
      | _ -> "/" in
      sprintf "to %s%s" dir slash
      

let saveBase ?(mark=None) ?(drop=None) ?(replace=None) ?(dash=true) suffix inName =      
  let replaced,str = String.replace inName ".mlb" "" in
  assert replaced;
  let name = match drop,replace with
  | Some sub, Some by -> begin let ok,res = String.replace ~str ~sub ~by in
    assert ok; res end
  | Some drop, None ->   dropText drop str
  | _ -> str in
  let daMark   = match mark with | Some x -> x^"-" | _ -> "" in
  let daDash   = if dash then "-" else "" in
  let infiks  = sprintf "%s%s%s" daDash daMark name in
  let suffiks = sprintf "%s.%s" infiks suffix in
  infiks, suffiks
  
let listNames saveSuffix prefixes = 
  L.map (flip (^) saveSuffix) prefixes
  
let reportTableNames inName asWhat outDir tableNames =
  leprintf "splitting %s as %s %s, new tables:" inName asWhat (showDir outDir); 
  L.print ~first:"" ~sep:", "~last:"\n" String.print stderr tableNames

let tableFileName suffix optDrop dataFileName =
  dataFileName |> 
  mayDropText optDrop |> dropText ".mlb" |> 
  flip (sprintf "%s.%s") suffix

let dayRange ?(takeDays=None) ?(dropDays=None) table =
  let day = Option.default 1 dropDays in
  let tableRange = listRange ~take:takeDays ~drop:dropDays table in
  day,tableRange

let dayRanges ?(takeDays=None) ?(dropDays=None) tables =
  let day = Option.default 1 dropDays in
  let tableRanges = L.map (listRange ~take:takeDays ~drop:dropDays) tables in
  day,tableRanges
  

  (* this works for floating-point tables only;
     first convert an integer to a float one *)
let tableAveragesAndMedians ?(filter1=false) t =
  let mayFilter1 l =
    if filter1 then L.filter (fun x -> x < 1.0) l
    else l
  in
  let ca = A.init (t |> L.hd |> L.length) (fun _ -> []) in
  L.iter begin fun day ->
    L.iteri begin fun i n ->
      ca.(i) <- n::ca.(i)
    end day  
  end t;
  let cl = A.to_list ca in
  let cl = L.map mayFilter1 cl in
  let averages = L.map Mathy.list_average cl
  and medians  = L.map Mathy.list_median  cl in
  averages,medians
  
  
let floatOfIntTable t =
  L.map (L.map float_of_int) t
  

let printSummary oc tex printOne name numbers =
  let first,sep,last = rowOrnaments tex in
  String.print oc name;
  L.print ~first ~sep ~last printOne oc numbers
  
  
let printShowSummary tex ~verbose printOne rowName numbers outDir fileName =
  let pathName = sprintf "%s/%s" outDir fileName in
  let oc = open_out pathName in
  printSummary oc tex printOne rowName numbers;
  close_out oc;
  if verbose then
    printSummary stdout tex printOne rowName numbers
  else ()
    
  
let tableSummary tex ~verbose ~outDir printOne ?(filter1=false) ?(drop=None) table name =
  let averages,medians = tableAveragesAndMedians ~filter1 table in
  let averagesName = sprintf "averages-%s" name in
  let mediansName  = sprintf "medians-%s"  name in
  let rowName = dropText (fileSuffix ~dot:true tex) name in
  let rowName = mayDropText drop rowName in
  printShowSummary tex ~verbose printOne rowName averages outDir averagesName;
  printShowSummary tex ~verbose printOne rowName medians  outDir mediansName
  

let tableSummaries tex ~verbose ~outDir printOne ?(filter1=false) ?(drop=None) tables tableNames =
  L.iter2 (tableSummary tex ~verbose ~outDir printOne ~filter1 ~drop) tables tableNames
  

let intTableSummaries tex ~verbose ~outDir printOne ?(filter1=false) ?(drop=None) tables tableNames =
  let floatTables = L.map floatOfIntTable tables in
  tableSummaries tex ~verbose ~outDir printOne ~filter1 ~drop floatTables tableNames
  
let loadTable ?(fromArray=false) fileName =
	if fromArray then loadData fileName |> A.to_list
							 else loadData fileName	