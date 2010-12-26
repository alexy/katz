open Common
open Binary_graph

let () =
  let args = getArgs in
  let (aranksName,ratesName) =
  match args with
    | aranksName::ratesName::restArgs -> (aranksName,ratesName)
    | _ -> failwith "usage: dorates aranks rates"
  in
  leprintfln "reading aranks from %s , saving rates in %s" 
  aranksName ratesName;

  let aranks: Cranks.day_rank_users = loadData aranksName in

  let rates = Topsets.bucketDynamics aranks in
  saveData rates ratesName
