open Common
open Binary_graph

let () =
  let args = getArgs in
  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dobuckles bucksName"      
  in  

  let lensName = "le"^bucksName in
  leprintfln "reading buckets from %s, saving lengths in %s" 
    bucksName lensName;

  let bucks:  Dcaps.day_log_buckets = loadData bucksName in
  let lens =  Dcaps.bucket_lens bucks in
  
  saveData lens lensName
