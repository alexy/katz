(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common
open Getopt

let checkSums = ref true
let specs =
[
  (noshort,"nocheck",(set checkSums false),None)
]

let () =
  let args = getOptArgs specs in
  
  let dnumsName,bucksName,byMents =
  match args with
    | dnumsName::bucksName::"m"::restArgs -> dnumsName,bucksName,true
    | dnumsName::bucksName::restArgs -> dnumsName,bucksName,false
    | _ -> failwith "usage: volume dnumsName bucksName"      
  in  

  let volsName = (if byMents then "m" else "r")^"vols2-"^bucksName in
  leprintfln "reading dnums from %s, using %s, bucks from %s, saving volumes in %s" 
    dnumsName (if byMents then "mentions" else "replies") bucksName volsName;

  let dnums: day_rep_nums = loadData dnumsName in
  let bucks: day_buckets  = loadData bucksName in
  
  let vols: bucket_volumes2 = Volume.bucket_volumes2 !checkSums dnums bucks in
  
  saveData vols volsName
