open Common

let () =
  let args = getArgs in
  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dobuckles bucksName"      
  in  

  let baseName = cutPath bucksName in
  let lensName = "le"^baseName in
  leprintfln "reading buckets from %s, saving lengths in %s" 
    bucksName lensName;

  let bucks:  day_log_buckets = loadData bucksName in
  let lens =  Dcaps.bucket_lens bucks in
  
  saveData lens lensName
