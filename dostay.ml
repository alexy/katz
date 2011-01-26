open Common

let () =
  let args = getArgs in
  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dostay bucksName"
  in
  
  let saveName = "stay-"^bucksName in
  leprintfln "reading bucks from %s , saving stays in %s" 
  bucksName saveName;

  let bucks: Topsets.day_buckets = loadData bucksName in

  let stays = Bucket_power.staying bucks in
  
  saveData stays saveName
