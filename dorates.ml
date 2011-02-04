open Common
open Getopt

(* srates stand for staying rates *)

let prefix' = ref "srates"
let specs =
[
  ('p',"prefix",None,Some (fun x -> prefix' := x))
]

let () =
  let args = getOptArgs specs in
  
  let prefix = !prefix' in
  
  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dorates bucksName"
  in
  
  let saveName = sprintf "%s-%s" prefix bucksName in
  leprintfln "reading bucks from %s, saving rates in %s" 
  bucksName saveName;

  let bucks: day_buckets = loadData bucksName in

  let rates = Topsets.bucketDynamics bucks in
  leprintfLn;
  
  Topsets.show_rates rates;
  
  saveData rates saveName
