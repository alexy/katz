(* compute starbucks *)
   
open Common

let () =
  let args = getArgs in

  let bucksName,starsName =
  match args with
    | bucksName::starsName::restArgs -> bucksName,starsName
    | _ -> failwith "usage: dostarbucks  bucksName starsName"      
  in  

  let sbucksName = "sbucks-"^starsName in
  leprintfln "reading bucks from %s, starrank from %s, storing starbucks in %s" bucksName starsName sbucksName;

  let bucks: day_buckets = loadData bucksName in
  let stars: starrank    = loadData starsName in
  
  let srankh             = Starrank.starrank_hash stars in
  let sbucks             = Starrank.starbucks bucks srankh in
  
  saveData sbucks sbucksName
