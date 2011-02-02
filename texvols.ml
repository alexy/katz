open Common
open Getopt
open TeX

(* tabulate a vols4 data as 4 tables *)

let texr = ref false
let docr = ref false

let specs =
[
  ('t',"tex",(set texr true),None);
  ('d',"doc",(set docr true),None)
]

let _ =
  let args = getOptArgs specs in

  
  let tex =
  match !texr,!docr with
  | true,true  -> DocTeX
  | true,false -> TeX
  | _          -> Plain in
  
  let vols4Name = 
  match args with
  | x::[] -> x
  | _ -> failwith "usage: texvols vols4Name"
  in

  let tableNames = L.map (flip (^) vols4Name) ["re";"ru";"me";"mu"] in
  leprintf "splitting %s into " vols4Name; 
  L.print ~first:"" ~sep:", "~last:"\n" String.print stderr tableNames;
  
  let als_list x = (array_list_split |- fun (a,b) -> A.to_list a, A.to_list b) x in
  
  let vols4: bucket_volumes4 = loadData vols4Name in
  let (re,ru),(me,mu) = array_list_split vols4 |> 
    fun (v,w) -> als_list v, als_list w in
  let tables = [re;ru;me;mu] in
  
  L.iter2 begin fun table tableName -> 
    let oc = open_out tableName in
    print_table oc     tex tableName Int.print table; close_out oc;
    print_table stdout tex tableName Int.print table;
  end tables tableNames