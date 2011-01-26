open Common

let () =
  let args = getArgs in
  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dorates bucksName"
  in
  
  let saveName = "rates-"^bucksName in
  leprintfln "reading bucks from %s , saving rates in %s" 
  bucksName saveName;

  let bucks: Topsets.day_buckets = loadData bucksName in

  let rates = Topsets.bucketDynamics bucks in
  leprintfln "";
  
  Topsets.show_rates rates;
  
  saveData rates saveName
