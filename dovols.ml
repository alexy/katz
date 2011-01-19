(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common

let () =
  let args = getArgs in
  let denumsName,aranksName =
  match args with
    | denumsName::aranksName::restArgs -> denumsName,aranksName
    | _ -> failwith "usage: volume denumsName aranksName"      
  in  

  let volsName = "vols-"^aranksName in
  leprintfln "reading denums from %s, aranks from %s, saving volumes in %s" 
    denumsName aranksName volsName;

  let denums: By_day.day_edgenums   = loadData denumsName in
  let aranks: Cranks.day_rank_users = loadData aranksName in
  
  let vols = Volume.bucket_volumes denums aranks in
  
  saveData vols volsName
