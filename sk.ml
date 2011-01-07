open Common
open Load_graph
open Soc_run_skew

(* TODO optionize *)
let by_mass = true
  
let () = 
  let args = getArgs in
  match args with
  | drepsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s, saving dcaps in %s" drepsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let (dreps,tLoad) = loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    let dments = Invert.invert2 dreps in
    let tInvert = Some "inverted dreps into dments, timing: " |> getTiming in
    leprintfln "dments has length %d" (H.length dments);
    let ({dcapsSG =dcaps; dskewsSG =dskews},tSocRun) = socRun dreps dments {optSocRun with maxDaysSR= maxDays; byMassSR= by_mass} in
    leprintfln "computed sgraph, now saving dcaps in %s" saveName;
    (* saveData dcaps saveName; *)
    saveData dskews saveName;
    let tSaving =  Some "saved dcaps timing: " |> getTiming in
    let ts = List.rev (tSaving::tSocRun@[tInvert]@tLoad) in
    printf "timings: %s\n" (show_float_list ts);
  end
  | _ -> leprintf "usage: sc drepsName dcapsName"
