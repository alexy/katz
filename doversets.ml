open Common
open Topsets
open Getopt

let oratesNow' = ref true
let saveOverY' = ref false

let specs =
[
  ('o',"orates",(set oratesNow' (not !oratesNow')),None);
  ('y',"orates",(set saveOverY' (not !saveOverY')),None)
]

let () =
  let args = getOptArgs specs in
  
  let oratesNow,   saveOverY = 
      !oratesNow', !saveOverY' in

  let b1Name,b2Name,saveBase =
  match args with
    | b1Name::b2Name::saveBase::restArgs -> (b1Name,b2Name,saveBase)
    | _ -> failwith "usage: doverlaps b1Name b2Name saveBase"
  in
  let saveSuffix = saveBase^".mlb" in
  let osetsName  = "overs-"^saveSuffix  in
  let oratesName = "orates-"^saveSuffix in
  let overxName  = "overx-"^saveSuffix  in
  let overyName  = "overy-"^saveSuffix  in
  
  leprintf "reading buckets from %s and %s, saving fraction to left in %s, "
    b1Name b2Name overxName;
    
  if saveOverY then leprintf "fraction to the right in %s" overyName
               else leprintf "not saving overy";
  leprintf ", ";
  if oratesNow then leprintfln "saving staying rates in overlaps in %s" oratesName
               else leprintfln "saving overlaps as %s" osetsName;
  
  let b1: day_buckets = loadData b1Name in
  let b2: day_buckets = loadData b2Name in

  let (osets:day_buckets),(overx:rates),(overy:rates) = bucketOverlapSetsRatios b1 b2 in
  
  show_rates overx;  
  saveData overx overxName;

  if oratesNow then begin
    let orates = Topsets.bucketDynamics osets in
    saveData orates oratesName
    end
  else
    saveData osets osetsName;
  
  if saveOverY then saveData overy overyName
