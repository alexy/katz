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

  let bucksName = "rbucks-"^aranksName in
  leprintfln "reading aranks from %s, saving buckets in %s" 
    aranksName bucksName;

  let aranks: Cranks.day_rank_users = loadData aranksName in
  
  let bucks = A.map Topsets.buckets aranks in
  
  saveData bucks bucksName
