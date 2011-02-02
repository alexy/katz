open Common

type tex = TeX | DocTeX | Plain

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