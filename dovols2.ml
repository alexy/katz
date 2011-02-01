(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common
open Getopt

let check_sums = ref true
let by1        = ref false
let specs =
[
  (noshort,"nocheck",(set check_sums false),None);
  ('1',"by1",(set by1 true),None)
]

let () =
  let args = getArgs in
  let denumsName,bucksName,byMents =
  match args with
    | denumsName::bucksName::"m"::restArgs -> denumsName,bucksName,true
    | denumsName::bucksName::restArgs -> denumsName,bucksName,false
    | _ -> failwith "usage: volume denumsName bucksName"      
  in  

  let volsName = (if byMents then "m" else "r")^"vols-"^bucksName in
  leprintfln "reading denums from %s, using %s, bucks from %s, saving volumes in %s" 
    denumsName (if byMents then "mentions" else "replies") bucksName volsName;

  let denums: day_edgenums = loadData denumsName in
  let bucks:  day_buckets  = loadData bucksName in
  
  let reps,ments = array_split denums in
  
  let vr,vm = 
  if !by1 then
    let array_hash_split a = A.map hash_split a |> array_split in
    
    let re,ru = array_hash_split reps  in
    let me,mu = array_hash_split ments in
  
    let vre = Volume.bucket_volumes !check_sums re bucks in
    let vru = Volume.bucket_volumes !check_sums ru bucks in
    let vme = Volume.bucket_volumes !check_sums me bucks in
    let vmu = Volume.bucket_volumes !check_sums mu bucks in
    
    let vr = A.map2 L.combine vre vru in
    let vm = A.map2 L.combine vme vmu in
    vr,vm
  else
    let vr =  Volume.bucket_volumes2 !check_sums reps  bucks in
    let vm =  Volume.bucket_volumes2 !check_sums ments bucks in
    vr,vm
  in
  let vols: bucket_volumes4 = A.map2 L.combine vr vm in
    
  saveData vols volsName
