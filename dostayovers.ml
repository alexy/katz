(* compute starranks *)
   
open Common
open Getopt

let days  = ref 7
let mark  = ref ""
let specs =
[
  ('d',"days",None,Some (fun x -> days := int_of_string x));
  ('k',"mark",None,Some (fun x -> mark := x))
]

let () =
  let args = getOptArgs specs in

  let staysName =
  match args with
    | staysName::restArgs -> staysName
    | _ -> failwith "usage: dostayovers staysName"      
  in  
  
  let prefix = sprintf "stov-d%d-" !days in
  let suffix = !mark^staysName in
  let stovUsrsName = prefix^"usrs-"^suffix in
  let stovNumsName = prefix^"nums-"^suffix in
  leprintfln "reading stays from %s, computing stayovers for %d days, saving usrs in %s, nums in %s" 
    staysName !days stovUsrsName stovNumsName;

  let stays: staying = loadData staysName in
  
  let (usrs : staying),(nums : staying_totals) = Bucket_power.stay_over stays !days in
  
  saveData usrs stovUsrsName;
  saveData nums stovNumsName;
  
  A.print ~last:"|]\n" Int.print stdout nums
