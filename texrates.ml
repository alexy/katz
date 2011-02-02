(* read rates and typeset a LaTeX table *)
open Common
open TeX

(* Float.print would do, but it doesn't control for precision *)
let floatPrint oc x = fprintf oc "%5.2f" x
  
let () =
  let args = getArgs in
  let ratesName,tex =
  match args with
  | x::"alltex"::_ -> x,DocTeX
  | x::"tex"::_    -> x,TeX
  | x::[]          -> x,Plain
  | _ -> failwith "texrates ratesName [tex|alltex]"
  in
  
  let suffix,what = match tex with | TeX | DocTeX _ -> ".tex","latex" | _ -> ".txt","text" in
    let replaced,saveBase = String.replace ratesName ".mlb" "" in
    assert replaced;
    let saveName = saveBase^suffix in
    leprintfln "reading rates from %s, writing %s to %s"
      ratesName what saveName;
  
  let rates : rates = loadData ratesName in

  let oc = open_out saveName in
  print_table oc     tex saveBase floatPrint rates; close_out oc;
  print_table stdout tex saveBase floatPrint rates
  