(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common

let () =
  let args = getArgs in
  let dnumsName,bucksName,byMents =
  match args with
    | dnumsName::bucksName::"m"::restArgs -> dnumsName,bucksName,true
    | dnumsName::bucksName::restArgs -> dnumsName,bucksName,false
    | _ -> failwith "usage: volume dnumsName bucksName"      
  in  

  let volsName = (if byMents then "m" else "r")^"vols-"^bucksName in
  leprintfln "reading dnums from %s, using %s, bucks from %s, saving volumes in %s" 
    dnumsName (if byMents then "mentions" else "replies") bucksName volsName;

  let dnums: By_day.day_rep_nums = loadData dnumsName in
  let bucks: Topsets.day_buckets = loadData bucksName in
  
  let rnums = A.map (H.map (fun _ x -> fst x)) dnums in

  let vols = Volume.bucket_volumes rnums bucks in
  
  saveData vols volsName
