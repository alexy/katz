(* read rates and typeset a LaTeX table *)
open Common

(* Float.print would do, but it doesn't control for precision *)
let column_print oc x = fprintf oc "%5.2f" x
  
type tex = TeX | AllTeX | Plain

let print_table oc tex name rates =
  let anyTeX,allTeX = 
  match tex with
  | AllTeX -> true,true
  | TeX    -> true,false
  | _      -> false,false
  in

  if allTeX then
    fprintf oc "
\\documentclass{article}
\\begin{document}    
" else ();

  if anyTeX then
    fprintf oc "
  \\begin{table}
	\\caption{%s}
	\\label{table:TODO-LABEL}
	\\centering
	\\begin{tabular}{|c|c|c|c|c|c|c|c|}
	\\hline
	\\emph{day} & 1 & 10 & 100 & 1,000 & 10,000 & 100,000 & 1,000,000 \\\\
	\\hline
	\\hline	
" name else ();
  
  L.iteri begin fun day rs ->
    fprintf oc "%d" (day+7) ;
    if anyTeX then begin
      L.print ~first:" & "~sep:" & " ~last:"\\\\\n" column_print oc rs;
      fprintf oc "\\hline\n"
      end
    else
      L.print ~first:"" ~sep:" " ~last:"\n" column_print oc rs
  end (rates |> L.take 34 |> L.drop 7);
  
  if anyTeX then
    fprintf oc "
\\end{tabular}
\\end{table}
" else ();

  if allTeX then
    fprintf oc "
\\end{document}    
" else ()
  
  
let () =
  let args = getArgs in
  let ratesName,tex =
  match args with
  | x::"alltex"::_ -> x,AllTeX
  | x::"tex"::_    -> x,TeX
  | x::[]          -> x,Plain
  | _ -> failwith "texrates ratesName [tex|alltex]"
  in
  
  let suffix,what = match tex with | TeX | AllTeX _ -> ".tex","latex" | _ -> ".txt","text" in
    let replaced,saveBase = String.replace ratesName ".mlb" "" in
    assert replaced;
    let saveName = saveBase^suffix in
    leprintfln "reading rates from %s, writing %s to %s"
      ratesName what saveName;
  
  let rates : rates = loadData ratesName in

  let oc = open_out saveName in
  print_table oc     tex saveBase rates; close_out oc;
  print_table stdout tex saveBase rates
  