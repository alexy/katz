(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common
open Getopt

let checkSums' = ref true
let by1'       = ref false
let specs =
[
  (noshort,"nocheck",(set checkSums' false),None);
  ('1',"by1",(set by1' true),None)
]

let () =
  let args = getOptArgs specs in
  
  let checkSums,   by1 =
      !checkSums', !by1' in
  
  let denumsName,bucksName =
  match args with
    | denumsName::bucksName::restArgs -> denumsName,bucksName
    | _ -> failwith "usage: volume denumsName bucksName"      
  in  

  let baseName = cutPath bucksName in
  let volsName = "vols4-"^baseName in
  leprintfln "reading denums from %s, bucks from %s, saving volumes in %s" 
    denumsName bucksName volsName;

  let denums: day_edgenums = loadData denumsName in
  let bucks:  day_buckets  = loadData bucksName in
  
  let reps,ments = array_split denums in
  
  let vr,vm = 
  if by1 then    
    let re,ru = array_hash_split reps  in
    let me,mu = array_hash_split ments in
  
    let vre = Volume.bucket_volumes checkSums re bucks in
    let vru = Volume.bucket_volumes checkSums ru bucks in
    let vme = Volume.bucket_volumes checkSums me bucks in
    let vmu = Volume.bucket_volumes checkSums mu bucks in
    
    let vr = A.map2 L.combine vre vru in
    let vm = A.map2 L.combine vme vmu in
    vr,vm
  else
    let vr =  Volume.bucket_volumes2 checkSums reps  bucks in
    let vm =  Volume.bucket_volumes2 checkSums ments bucks in
    vr,vm
  in
  let vols: bucket_volumes4 = A.map2 L.combine vr vm in
    
  saveData vols volsName
