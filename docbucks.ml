open Common

let () =
  let args = getArgs in
  let jcapsName =
  match args with
    | jcapsName::restArgs -> jcapsName
    | _ -> failwith "usage: dobucks jcapsName"      
  in  

  let bucksName = "lb-"^jcapsName in
  leprintfln "reading jcaps from %s, saving buckets in %s" 
    jcapsName bucksName;

  let jcaps:  day_caps = loadData jcapsName in
  let bucks = A.map Dcaps.bucketize2 jcaps in
  
  saveData bucks bucksName
