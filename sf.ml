open Common
open Soc_run_fof
open Getopt

let byMass'  = ref true
let minDays' = ref 7
let minCap'  = ref 1e-35
let jumpProbUtil' = ref 0.5 (* maximize utility or just jump in general *)
let jumpProbFOF'  = ref 0.2 (* atach globally after first jump vs FOF-based *)
let globalStrat'  = ref GlobalUniformAttachment
let fofStrat'     = ref FOFUniformAttachment
let mark' = ref ""

let specs =
[
  ('c',"mincap",None,Some (fun x -> minCap' := float_of_string x));
  ('k',"mark",  None,Some (fun x -> mark' := x));
  ('u',"byusers",(set byMass' false),None);
  (noshort,"nomindays",(set minDays' 0),None);
  ('d',"mindays",None,Some (fun n -> minDays' := int_of_string n));
  ('j',"jumpUtil",None,Some (fun x -> jumpProbUtil' := float_of_string x));
  ('J',"jumpFOF", None,Some (fun x -> jumpProbFOF'  := float_of_string x));
  (noshort,"glouni",(set globalStrat' GlobalUniformAttachment), None);
  (noshort,"glomen",(set globalStrat' GlobalMentionsAttachment),None);
  (noshort,"fofuni", (set fofStrat'    FOFUniformAttachment),    None);
  (noshort,"fofmen", (set fofStrat'    FOFMentionsAttachment),   None);
  (noshort,"fofcap", (set fofStrat'    FOFSocCapAttachment),     None)
]
  
let () = 
  let args = getOptArgs specs in
  
  let byMass,   minDays,   minCap,   mark =
      !byMass', !minDays', !minCap', !mark' in
  
  let jumpProbUtil,   jumpProbFOF,   globalStrat,   fofStrat =
      !jumpProbUtil', !jumpProbFOF', !globalStrat', !fofStrat' in
      
  let (dstartsName,drnumsName,saveBase,dreps',day') =
  match args with
  | dstartsName::drnumsName::saveBase::dreps'::day'::[] -> 
      (dstartsName,drnumsName,saveBase,Some dreps',Some day')
  | dstartsName::drnumsName::saveBase::[] -> 
      (dstartsName,drnumsName,saveBase,None,None)
  | _ -> failwith "usage: sg dtartsName drnumsName saveBase [drepsName initDay]"
  in
  let saveSuffix = saveBase^".mlb" in
  let drepsName  = "dreps-"^saveSuffix in
  let dmentsName = "dments-"^saveSuffix in
  let capsName   = "caps-"^saveSuffix in
  let skewName   = "skew-"^saveSuffix in
  let jumpName   = "jump-"^saveSuffix in
  leprintfln "reading dstarts from %s and drnums from %s, saving dreps in %s, dments in %s, dcaps in %s and dskews in %s" 
    dstartsName drnumsName drepsName dmentsName capsName skewName;
    
  let globalStrategyName = showStrategy globalStrat in
  let fofStrategyName    = showStrategy fofStrat in
  leprintfln "options: byMass=%b, minDays=%d, minCap=%e, jumpProbUtil=%e, jumpProbFOF=%e, globalStrategy=%s, fofStrategy=%s" 
    byMass minDays minCap jumpProbUtil jumpProbFOF globalStrategyName fofStrategyName;
  
  let dstarts: starts      = loadData dstartsName in
  let tLoadDStarts =  Some "-- loaded dstarts timing: " |> getTiming in
  let drnums: day_rep_nums = loadData drnumsName in
  let tLoadDRnums  =  Some "-- loaded denums timing: "  |> getTiming in
  
  let (initDrepsO,initDayO) = match dreps' with
  | Some drepsName ->
          let day = day' |> Option.get |> int_of_string in
          leprintfln "based on %s through day %d" drepsName day;
          let dreps: graph = loadData drepsName in
          (Some dreps, Some day)
  | _ -> (None, None) in

                             
  let strategies = [globalStrat;fofStrat] in
  let strategyFeatures = computeStrategyFeatures strategyFeaturesInOrder strategies in
  L.print ~first:"overall strategy features to compute, in order:\n  "
  ~sep:", " ~last:"\n" String.print stderr strategyFeatures;
  
  let opts = {optSocRun with (* maxDaysSR= maxDays; *) byMassSR= byMass;
                             initDrepsSR= initDrepsO; initDaySR= initDayO;
                             minCapSR= minCap;
 (* minCapDaysSR=0 means raw 1 capital for attachment, no maturity at all! *) 
                             minCapDaysSR= minDays;
                             jumpProbUtilSR= jumpProbUtil;jumpProbFOFSR= jumpProbFOF;
                             globalStrategySR= globalStrat; fofStrategySR= fofStrat;
                             strategyFeaturesSR= strategyFeatures }
                             in
                             
  let {drepsSG =dreps; dmentsSG =dments},
    dcaps,dskews,countsTimings = socRun dstarts drnums opts in
    
  let edgeCounts,tSocRun = L.split countsTimings in
    
  leprintfln "computed sgraph, now saving dreps in %s, dments in %s, dcaps in %s, dskews in %s, jumps in %s" 
    drepsName dmentsName capsName skewName jumpName;
  saveData dreps  drepsName;
  let tSavingDReps  =  Some "-- saved dreps timing: "  |> getTiming in
  saveData dments dmentsName;  
  let tSavingDMents =  Some "-- saved dments timing: " |> getTiming in
  saveData dcaps  capsName;
  let tSavingDCaps  =  Some "-- saved dcaps timing: "  |> getTiming in
  saveData dskews skewName;
  let tSavingDSkews =  Some "-- saved dskews timing: " |> getTiming in
  saveData edgeCounts jumpName;
  
  let ts = List.rev (tSavingDSkews::tSavingDCaps::tSavingDMents::tSavingDReps::tSocRun@[tLoadDRnums;tLoadDStarts]) in
  printf "timings: %s\n" (show_float_list ts);
