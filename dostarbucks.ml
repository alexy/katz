(* compute starbucks *)
   
open Common
open Getopt

let mark  = ref ""
let specs =
[
  ('k',"mark",None,Some (fun x -> mark := x))
]

let () =
  let args = getOptArgs specs in

  let bucksName,starsName =
  match args with
    | bucksName::starsName::restArgs -> bucksName,starsName
    | _ -> failwith "usage: dostarbucks  bucksName starsName"      
  in  

  let sbucksName = "sbucks-"^(!mark)^starsName in
  leprintfln "reading bucks from %s, starrank from %s, storing starbucks in %s" bucksName starsName sbucksName;

  let bucks: day_buckets = loadData bucksName in
  let stars: starrank    = loadData starsName in
  
  let srankh                = Starrank.starrank_hash stars in
  let sbucks: day_starbucks = Starrank.starbucks bucks srankh in
  
  saveData sbucks sbucksName
