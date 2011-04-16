open Common
open Soc_run_fof
open Getopt

let alpha'        = ref 0.1
let beta'         = ref 0.5
let gamma'        = ref 0.5
let allDown'      = ref false
let byMass'       = ref true
let minDays'      = ref 7
let minCap'       = ref 1e-35
let jumpProbUtil' = ref 0.5 (* maximize utility or just jump in general *)
let jumpProbFOF'  = ref 0.2 (* atach globally after first jump vs FOF-based *)
let globalStrat'  = ref GlobalUniformAttachment
let fofStrat'     = ref FOFUniformAttachment
let denums2'      = ref true
let saveMents'    = ref false
let buckets'      = ref None
let keepBuckets'  = ref false

let prefixDreps'  = ref "dreps"
let outdirDreps'  = ref (Some !prefixDreps')
let prefixDments' = ref "dments"
let outdirDments' = ref (Some !prefixDments')
let prefixCaps'   = ref "caps"
let outdirCaps'   = ref (Some !prefixCaps')
let prefixSkew'   = ref "skew"
let outdirSkew'   = ref (Some !prefixSkew')
let prefixNorms'  = ref "norms"
let outdirNorms'  = ref (Some !prefixNorms')
let prefixJump'   = ref "jump"
let outdirJump'   = ref (Some !prefixJump')
let mark' = ref ""

let specs =
[
  (noshort,"prefixDreps",None, Some (fun x -> prefixDreps' := x));
  (noshort,"outdirDreps",None, Some (fun x -> outdirDreps' := Some x));
  (noshort,"nodirDreps",                 (set outdirDreps' None), None);
  (noshort,"prefixDments",None,Some (fun x -> prefixDments' := x));
  (noshort,"outdirDments",None,Some (fun x -> outdirDments' := Some x));
  (noshort,"nodirDments",                (set outdirDments' None), None);
  (noshort,"prefixCaps",None,  Some (fun x -> prefixCaps' := x));
  (noshort,"outdirCaps",None,  Some (fun x -> outdirCaps' := Some x));
  (noshort,"nodirCaps",                  (set outdirCaps' None), None);
  (noshort,"prefixSkew",None,  Some (fun x -> prefixSkew' := x));
  (noshort,"outdirSkew",None,  Some (fun x -> outdirSkew' := Some x));
  (noshort,"nodirSkew",                  (set outdirSkew' None), None);
  (noshort,"prefixNorms",None, Some (fun x -> prefixNorms' := x));
  (noshort,"outdirNorms",None, Some (fun x -> outdirNorms' := Some x));
  (noshort,"nodirNorms",                 (set outdirNorms' None), None);
  (noshort,"prefixJump",None,  Some (fun x -> prefixJump' := x));
  (noshort,"outdirJump",None,  Some (fun x -> outdirJump' := Some x));
  (noshort,"nodir",                      (set outdirJump' None), None);
  (noshort,"alpha",None,       Some (fun x -> alpha' := float_of_string x));
  (noshort,"beta", None,       Some (fun x -> beta'  := float_of_string x));
  (noshort,"gamma",None,       Some (fun x -> gamma' := float_of_string x));
  (noshort,"alldown",  (set allDown' true), None);
  (noshort,"noalldown",(set allDown' false),None);
  ('c',"mincap",None,Some (fun x -> minCap' := float_of_string x));
  ('k',"mark",  None,Some (fun x -> mark' := x));
  ('u',"byusers",(set byMass' false),None);
  (noshort,"nomindays",(set minDays' 0),None);
  ('d',"mindays",None,Some (fun n -> minDays' := int_of_string n));
  ('j',"jumpUtil",None,Some (fun x -> jumpProbUtil' := float_of_string x));
  (noshort,"noutil", (set jumpProbUtil' 1.0),                    None); 
  ('J',"jumpFOF", None,Some (fun x -> jumpProbFOF'  := float_of_string x));
  (noshort,"glouni", (set globalStrat' GlobalUniformAttachment), None);
  (noshort,"glomen", (set globalStrat' GlobalMentionsAttachment),None);
  (noshort,"glocap", (set globalStrat' GlobalSocCapAttachment),  None);
  (noshort,"fofuni", (set fofStrat'    FOFUniformAttachment),    None);
  (noshort,"fofmen", (set fofStrat'    FOFMentionsAttachment),   None);
  (noshort,"fofcap", (set fofStrat'    FOFSocCapAttachment),     None);
  (noshort,"fofnone",(set fofStrat'    NoAttachment),            None);
  ('b',"buckets",None, Some (fun x -> buckets' := Some (parseIntList x)));
  (noshort,"keepbuckets",(set keepBuckets' (not !keepBuckets')), None);
  ('2',"denums",(set denums2' (not !denums2')), None);
  ('m',"ments",(set saveMents' (not !saveMents')),None);
  ('r',"rand",None,Some (fun x -> randInit (int_of_string x)))
]
  
let () = 
  let args = getOptArgs specs in
  
  let alpha,   beta,   gamma,   allDown =
      !alpha', !beta', !gamma', !allDown' in
  
  let byMass,   minDays,   minCap,   denums2,   saveMents,   mark =
      !byMass', !minDays', !minCap', !denums2', !saveMents', !mark' in
  
  let jumpProbUtil,   jumpProbFOF,   globalStrat,   fofStrat,   buckets, keepBuckets =
      !jumpProbUtil', !jumpProbFOF', !globalStrat', !fofStrat', !buckets', !keepBuckets' in
      
  let prefixDreps, outdirDreps, prefixDments, outdirDments, prefixCaps, outdirCaps =
      !prefixDreps', !outdirDreps', !prefixDments', !outdirDments', !prefixCaps', !outdirCaps' in
      
  let prefixSkew, outdirSkew, prefixNorms, outdirNorms, prefixJump, outdirJump =
      !prefixSkew', !outdirSkew', !prefixNorms', !outdirNorms', !prefixJump', !outdirJump' in
  
      
  let dstartsName,denumsName,saveBase,dreps',day' =
  match args with
  | dstartsName::denumsName::saveBase::dreps'::day'::[] -> 
      (dstartsName,denumsName,saveBase,Some dreps',Some day')
  | dstartsName::denumsName::saveBase::[] -> 
      (dstartsName,denumsName,saveBase,None,None)
  | _ -> failwith "usage: sg dtartsName denumsName saveBase [drepsName initDay]"
  in
  let saveSuffix = saveBase ^ ".mlb" in
  let drepsName  = sprintf "%s-%s" prefixDreps  saveSuffix |> mayPrependDir outdirDreps  in
  let dmentsName = sprintf "%s-%s" prefixDments saveSuffix |> mayPrependDir outdirDments in
  let capsName   = sprintf "%s-%s" prefixCaps   saveSuffix |> mayPrependDir outdirCaps   in
  let skewName   = sprintf "%s-%s" prefixSkew   saveSuffix |> mayPrependDir outdirSkew   in
  let normsName  = sprintf "%s-%s" prefixNorms  saveSuffix |> mayPrependDir outdirNorms  in
  let jumpName   = sprintf "%s-%s" prefixJump   saveSuffix |> mayPrependDir outdirJump   in
  
  leprintfln begin "reading dstarts from %s and denums from %s, saving dreps in %s, dments in %s,\n"^^
             "caps in %s, skews in %s, norms in %s, jumps in %s\n" end
    dstartsName denumsName drepsName dmentsName capsName skewName normsName jumpName;
    
  let globalStrategyName = showStrategy globalStrat in
  let fofStrategyName    = showStrategy fofStrat in
  
  leprintf begin "options: " ^^
             "  alpha %f, beta %f, gamma %f, allDown %b\n" ^^ 
  	         "  byMass %b, minDays %d, minCap %e\n" ^^
             "  jumpProbUtil %e, jumpProbFOF %e\n" ^^
             "  globalStrategy %s, fofStrategy %s\n" end
    alpha beta gamma allDown byMass minDays minCap jumpProbUtil jumpProbFOF globalStrategyName fofStrategyName;
    
  Option.may begin L.print ~first:"buckets: [" 
                           ~last:(sprintf "], keepBuckets %b\n" keepBuckets) 
                           Int.print stderr 
             end buckets;
  
  let dstarts: starts      = loadData dstartsName in
  let tLoadDStarts =  Some "-- loaded dstarts timing: " |> getTiming in
  let drnums: day_rep_nums = 
    if denums2 then 
      let denums: day_edgenums = loadData denumsName in
      array_split denums |> fst
    else 
      loadData denumsName in
  let tLoadDRnums  =  Some "-- loaded denums timing: "  |> getTiming in
  
  let initDrepsOpt = Option.map begin
  fun drepsName ->
    (* the trailing space for the stderr output from loadData *)
    leprintf "based on %s " drepsName;
    let dreps: graph = loadData drepsName in
    dreps
  end dreps' in

  let initDayOpt = Option.map int_of_string day' in
  begin match initDayOpt with | Some day ->  leprintfln " through day %d" day | _ -> le_newline end;
                             
  let strategies = [globalStrat;fofStrat] @ (listOption (Option.map (constantly Buckets) buckets)) in
  
  let strategyFeatures = computeStrategyFeatures strategyFeaturesInOrder strategies in
  L.print ~first:"overall strategy features to compute, in order:\n  "
  ~sep:", " ~last:"\n" String.print stderr strategyFeatures;
  
  let opts = {optSocRun with (* maxDaysSR= maxDays; *) 
  													 alphaSR= alpha; betaSR= beta; gammaSR= gamma;
                             byMassSR= byMass;
                             initDrepsSR= initDrepsOpt; initDaySR= initDayOpt;
                             minCapSR= minCap;
 (* minCapDaysSR=0 means raw 1 capital for attachment, no maturity at all! *) 
                             minCapDaysSR= minDays;
                             jumpProbUtilSR= jumpProbUtil;jumpProbFOFSR= jumpProbFOF;
                             globalStrategySR= globalStrat; fofStrategySR= fofStrat;
                             strategyFeaturesSR= strategyFeatures; 
                             bucketsSR= buckets; keepBucketsSR= keepBuckets }
                             in
                             
  let {drepsSG =dreps; dmentsSG =dments},
    dcaps,dskews,countsTimings = socRun dstarts drnums opts in
    
  let normsEdgeCounts,tSocRun = L.split countsTimings in
  let norms,edgeCounts        = L.split normsEdgeCounts in
    
  leprintfln "computed sgraph, now saving dreps in %s, dments in %s, dcaps in %s, dskews in %s, jumps in %s" 
    drepsName dmentsName capsName skewName jumpName;

  mayMkDir outdirDreps;
  saveData dreps  drepsName;

  let tSavingDReps  =  Some "-- saved dreps timing: "  |> getTiming in
  let msg = if saveMents then begin 
    mayMkDir outdirDments;
    saveData dments dmentsName; "-- saved dments timing: " 
  end
  else "-- did not save dments, timing: " in
  let tSavingDMents =  Some msg |> getTiming in

  mayMkDir outdirCaps;
  saveData dcaps  capsName;

  let tSavingDCaps  =  Some "-- saved dcaps timing: "  |> getTiming in

  mayMkDir outdirSkew;
  saveData dskews skewName;

  let tSavingDSkews =  Some "-- saved dskews timing: " |> getTiming in
  
  mayMkDir outdirNorms;
  saveData norms      normsName;
  
  mayMkDir outdirJump;
  saveData edgeCounts jumpName;
  
  let ts = List.rev (tSavingDSkews::tSavingDCaps::tSavingDMents::tSavingDReps::tSocRun@[tLoadDRnums;tLoadDStarts]) in
  printf "timings: %s\n" (show_float_list ts);
