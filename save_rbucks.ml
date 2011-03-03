(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common

let () =
  let args = getArgs in
  let aranksName =
  match args with
    | aranksName::restArgs -> aranksName
    | _ -> failwith "usage: execname aranksName"      
  in  

  let baseName = cutPath aranksName in
  let bucksName = "rbucks-"^baseName in
  leprintfln "reading aranks from %s, saving buckets in %s" 
    aranksName bucksName;

  let aranks: day_rank_users = loadData aranksName in
  
  let bucks: day_buckets = A.map Topsets.buckets aranks in
  
  saveData bucks bucksName
