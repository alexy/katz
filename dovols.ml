(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common

let () =
  let args = getArgs in
  let denumsName,bucksName,byMents =
  match args with
    | denumsName::bucksName::"m"::restArgs -> denumsName,bucksName,true
    | denumsName::bucksName::restArgs -> denumsName,bucksName,false
    | _ -> failwith "usage: volume denumsName bucksName"      
  in  

  let volsName = "vols-"^bucksName in
  leprintfln "reading denums from %s, using %s, bucks from %s, saving volumes in %s" 
    denumsName (if byMents then "mentions" else "replies") bucksName volsName;

  let denums: By_day.day_edgenums = loadData denumsName in
  let bucks: Topsets.day_buckets  = loadData bucksName in
  
  let repsOrMents = if byMents then snd else fst in
  let rnums = A.map (fst |- (H.map (fun _ x -> repsOrMents x))) denums in

  let vols = Volume.bucket_volumes rnums bucks in
  
  saveData vols volsName
