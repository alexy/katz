open Common
open Binary_graph

let () =
  let args = getArgs in
  let (jcapsName,bucksName) =
  match args with
    | jcapsName::bucksName::restArgs -> (jcapsName,bucksName)
    | _ -> failwith "usage: dobucks jcapsName bucksName"      
  in  

  leprintfln "reading jcaps from %s, saving buckets in %s" 
    jcapsName bucksName;

  let jcaps:  Dcaps.day_caps = loadData jcapsName in
  let bucks = A.map Dcaps.bucketize2 jcaps in
  
  saveData bucks bucksName
