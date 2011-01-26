open Common

let () =
  let args = getArgs in
  let (b1Name,b2Name,saveName) =
  match args with
    | b1Name::b2Name::saveName::restArgs -> (b1Name,b2Name,saveName)
    | _ -> failwith "usage: doverlaps b1Name b2Name saveName"
  in
  leprintfln "reading buckets from %s and %s, saving overlapping sets per bucket in %s" 
  b1Name b2Name saveName;

  let b1: Topsets.day_buckets = loadData b1Name in
  let b2: Topsets.day_buckets = loadData b2Name in

  let oversets = Topsets.bucketOverlapSets b1 b2 in
  
  saveData oversets saveName
