open Common

type tex = TeX | DocTeX | Plain

let texParams tex doc =
  match !tex,!doc with
  | true,true  -> DocTeX
  | true,false -> TeX
  | _          -> Plain
  

let print_table oc tex name printOne elems =
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
  end (elems |> L.take 34 |> L.drop 7);
  
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


let print_matrix oc doc tableNames =
  let mats = tables2x2 tableNames in
  let s = if doc then texDocument mats else mats in
  String.print oc s