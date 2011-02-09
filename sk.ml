open Common
open Load_graph
open Soc_run_skew

(* TODO optionize *)
let by_mass = true
  
let () = 
  let args = getArgs in
  let (drepsName,restArgs) =
  match args with
  | drepsName::restArgs -> (drepsName,restArgs)
  | _ -> failwith "usage: sk drepsName"
  in
  let capsName = "caps-"^drepsName in
  let skewName = "skew-"^drepsName in
  leprintfln "reading graph from %s, saving dcaps in %s and dskews in %s" 
    drepsName capsName skewName;
  let maxDays = restArgs |> List.map int_of_string |> option_of_list in
  let (dreps,tLoad) = loadAnyGraph drepsName in
  leprintfln "loaded %s, %d" drepsName (H.length dreps);
  let dments = Invert.invert2 dreps in
  let tInvert = Some "-- inverted dreps into dments, timing: " |> getTiming in
  leprintfln "dments has length %d" (H.length dments);
  let _,dcaps,dskews,tSocRun = 
    socRun dreps dments {optSocRun with maxDaysSR= maxDays; byMassSR= by_mass} in
  leprintfln "computed sgraph, now saving dcaps in %s and dskews in %s" capsName skewName;
  saveData dcaps  capsName;
  let tSavingDCaps  =  Some "-- saved dcaps timing: "  |> getTiming in
  saveData dskews skewName;
  let tSavingDSkews =  Some "-- saved dskews timing: " |> getTiming in
  let ts = List.rev (tSavingDSkews::tSavingDCaps::tSocRun@[tInvert]@tLoad) in
  printf "timings: %s\n" (show_float_list ts);
