open Common

let () =
  let args = getArgs in
  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dobuckles bucksName"      
  in  

  let lensName = "rblens-"^bucksName in
  leprintfln "reading buckets from %s, saving lengths in %s" 
    bucksName lensName;

  let bucks: day_buckets = loadData bucksName in
  let lens: int_rates    = Bucket_power.bucket_lens bucks in
  
  saveData lens lensName
