open Common
open Soc_run_gen

(* TODO optionize *)
let by_mass = true
  
let () = 
  let args = getArgs in
  let (dstartsName,drnumsName,saveBase,restArgs) =
  match args with
  | dstartsName::drnumsName::saveBase::restArgs -> (dstartsName,drnumsName,saveBase,restArgs)
  | _ -> failwith "usage: sg dtartsName drnumsName saveBase"
  in
  let drepsName  = "dreps-"^saveBase in
  let dmentsName = "dments-"^saveBase in
  let capsName   = "caps-"^saveBase in
  let skewName   = "skew-"^saveBase  in
  leprintfln "reading dstarts from %s and drnums from %s, saving dreps in %s, dments in %s, dcaps in %s and dskews in %s" 
    dstartsName drnumsName drepsName dmentsName capsName skewName;
  let maxDays = restArgs |> List.map int_of_string |> option_of_list in
  
  let dstarts: Dranges.starts     = loadData dstartsName in
  let tLoadDStarts =  Some "-- loaded dstarts timing: " |> getTiming in
  let drnums: By_day.day_rep_nums = loadData drnumsName in
  let tLoadDRnums  =  Some "-- loaded denums timing: "  |> getTiming in
  
  let ({drepsSG =dreps; dmentsSG =dments;
    dcapsSG =dcaps; dskewsSG =dskews},tSocRun) = 
    socRun dstarts drnums {optSocRun with maxDaysSR= maxDays; byMassSR= by_mass} in
  leprintfln "computed sgraph, now saving dreps in %s, dments in %s, dcaps in %s and dskews in %s" 
    drepsName dmentsName capsName skewName;
  saveData dreps  drepsName;
  let tSavingDReps  =  Some "-- saved dreps timing: "  |> getTiming in
  saveData dments dmentsName;  
  let tSavingDMents =  Some "-- saved dments timing: " |> getTiming in
  saveData dcaps  capsName;
  let tSavingDCaps  =  Some "-- saved dcaps timing: "  |> getTiming in
  saveData dskews skewName;
  let tSavingDSkews =  Some "-- saved dskews timing: " |> getTiming in
  let ts = List.rev (tSavingDSkews::tSavingDCaps::tSavingDMents::tSavingDReps::tSocRun@[tLoadDRnums;tLoadDStarts]) in
  printf "timings: %s\n" (show_float_list ts);
