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
  let skewName = "skew-"^drepsName in
  leprintfln "reading graph from %s, saving dskews in %s" drepsName skewName;
  let maxDays = restArgs |> List.map int_of_string |> option_of_list in
  let (dreps,tLoad) = loadAnyGraph drepsName in
  leprintfln "loaded %s, %d" drepsName (H.length dreps);
  let dments = Invert.invert2 dreps in
  let tInvert = Some "inverted dreps into dments, timing: " |> getTiming in
  leprintfln "dments has length %d" (H.length dments);
  let ({dcapsSG =dcaps; dskewsSG =dskews},tSocRun) = 
    socRun dreps dments {optSocRun with maxDaysSR= maxDays; byMassSR= by_mass} in
  leprintfln "computed sgraph, now saving dskews in %s" skewName;
  (* saveData dcaps saveName; *)
  saveData dskews skewName;
  let tSaving =  Some "saved dskews timing: " |> getTiming in
  let ts = List.rev (tSaving::tSocRun@[tInvert]@tLoad) in
  printf "timings: %s\n" (show_float_list ts);
