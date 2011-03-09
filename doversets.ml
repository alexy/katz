open Common
open Topsets
open Getopt

let oratesNow'    = ref true
let saveOverY'    = ref false
let mark'         = ref ""
let prefixOverx'  = ref "overx"
let outdirOverx'  = ref (Some !prefixOverx')
let prefixOvery'  = ref "overy"
let outdirOvery'  = ref (Some !prefixOvery')
let prefixOvers'  = ref "overs"
let outdirOvers'  = ref (Some !prefixOvers')
let prefixOrates' = ref "orates"
let outdirOrates' = ref (Some !prefixOrates')
let outdirSuffix' = ref None

let specs =
[
  (noshort,"prefixOvers",None,Some (fun x ->  prefixOvers' := x));
  (noshort,"outdirOvers",None,Some (fun x ->  outdirOvers' := Some x));
  (noshort,"nodirOvers",                (set  outdirOvers' None), None);
  (noshort,"prefixOrates",None,Some (fun x -> prefixOrates' := x));
  (noshort,"outdirOrates",None,Some (fun x -> outdirOrates' := Some x));
  (noshort,"nodirOrates",                (set outdirOrates' None), None);
  (noshort,"prefixOverx",None,Some (fun x ->  prefixOverx' := x));
  (noshort,"outdirOverx",None,Some (fun x ->  outdirOverx' := Some x));
  (noshort,"nodirOverx",                 (set outdirOverx' None), None);
  (noshort,"prefixOvery",None,Some (fun x ->  prefixOvery' := x));
  (noshort,"outdirOvery",None,Some (fun x ->  outdirOvery' := Some x));
  (noshort,"nodirOvery",                 (set outdirOvery' None), None);
  ('s',"outdirSuffix",   None,Some (fun x ->  outdirSuffix' := Some x));
  (noshort,"nodirSuffix",                (set outdirSuffix' None), None);
  ('o',"orates",(set oratesNow' (not !oratesNow')),None);
  ('y',"orates",(set saveOverY' (not !saveOverY')),None);
  ('k',"mark",None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in
  
  let oratesNow,   saveOverY,   mark = 
      !oratesNow', !saveOverY', !mark' in
      
  let prefixOvers,   outdirOvers,   prefixOrates,   outdirOrates,   outdirSuffix =
      !prefixOvers', !outdirOvers', !prefixOrates', !outdirOrates', !outdirSuffix' in
  let prefixOverx,   outdirOverx,   prefixOvery,    outdirOvery =
      !prefixOverx', !outdirOverx', !prefixOvery',  !outdirOvery' in

  let b1Name,b2Name,saveBase,outdirSuffix =
  match args with
    | b1Name::b2Name::saveBase::outdirSuffix::restArgs -> b1Name,b2Name,saveBase,Some outdirSuffix
    | b1Name::b2Name::saveBase::restArgs -> b1Name,b2Name,saveBase,outdirSuffix
    | _ -> failwith "usage: doverlaps b1Name b2Name saveBase"
  in
  let saveSuffix = saveBase^".mlb" in
  let outdirOverx  = mayOptAppend outdirOverx  ~infix:"-" outdirSuffix in
  let outdirOvery  = mayOptAppend outdirOvery  ~infix:"-" outdirSuffix in
  let outdirOvers  = mayOptAppend outdirOvers  ~infix:"-" outdirSuffix in
  let outdirOrates = mayOptAppend outdirOrates ~infix:"-" outdirSuffix in
  let overxName  = sprintf "%s-%s%s" prefixOverx  mark saveSuffix |> mayPrependDir outdirOverx  in
  let overyName  = sprintf "%s-%s%s" prefixOvery  mark saveSuffix |> mayPrependDir outdirOvery  in
  let osetsName  = sprintf "%s-%s%s" prefixOvers  mark saveSuffix |> mayPrependDir outdirOvers  in
  let oratesName = sprintf "%s-%s%s" prefixOrates mark saveSuffix |> mayPrependDir outdirOrates in
  
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
  mayMkDir outdirOverx;
  saveData overx overxName;

  if oratesNow then begin
    let orates = Topsets.bucketDynamics osets in
    mayMkDir outdirOrates;
    saveData orates oratesName
    end
  else begin
    mayMkDir outdirOvers;
    saveData osets osetsName
  end;
  
  if saveOverY then begin
    mayMkDir outdirOvery;
    saveData overy overyName
  end