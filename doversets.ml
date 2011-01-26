open Common
open Topsets

let () =
  let args = getArgs in
  let (b1Name,b2Name,saveBase) =
  match args with
    | b1Name::b2Name::saveBase::restArgs -> (b1Name,b2Name,saveBase)
    | _ -> failwith "usage: doverlaps b1Name b2Name saveBase"
  in
  let osetsName = "overs-"^saveBase in
  let overxName = "overx-"^saveBase in
  let overyName = "overy-"^saveBase in
  
  leprintfln "reading buckets from %s and %s, saving bucket overlaps in %s, fraction to left in %s, to right in %s" 
  b1Name b2Name osetsName overxName overyName;

  let b1: day_buckets = loadData b1Name in
  let b2: day_buckets = loadData b2Name in

  let osets,overx,overy = bucketOverlapSetsRatios b1 b2 in
  
  leprintfln "-- overx: --";
  show_rates overx;
  leprintfln "-- overy: --";
  show_rates overy;
  
  saveData osets osetsName;
  saveData overx overxName;
  saveData overy overyName
