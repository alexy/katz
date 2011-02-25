open Common
open Getopt
open Load_graph
open Soc_run_skew

(* TODO optionize *)
let byMass'    = ref true
  
let specs =
[
  (noshort,"bymass",(set byMass' (not !byMass')), None)
]

let () = 
  let args = getOptArgs specs in
  
  let byMass =
      !byMass' in
  
  let drepsName,restArgs =
  match args with
  | drepsName::restArgs -> (drepsName,restArgs)
  | _ -> failwith "usage: sk drepsName"
  in
  let capsName = "caps-"^drepsName  in
  let skewName = "skew-"^drepsName  in
  let normsName= "norms-"^drepsName in
  leprintfln "reading graph from %s, saving dcaps in %s, dskews in %s, norms in %s" 
    drepsName capsName skewName normsName;
    
  let maxDays = restArgs |> List.map int_of_string |> option_of_list in

  let dreps,tLoad = loadAnyGraph drepsName in
  leprintfln "loaded %s, %d" drepsName (H.length dreps);
  
  let dments = 
    try
      Invert.invert2 dreps 
    with Not_found -> failwith "spurious Not_found, should have been handled in invert" in
  let tInvert = Some "-- inverted dreps into dments, timing: " |> getTiming in
  leprintfln "dments has length %d" (H.length dments);
  let norms,dcaps,dskews,tSocRun = 
    socRun dreps dments {optSocRun with maxDaysSR= maxDays; byMassSR= byMass} in
  leprintfln "computed sgraph, now saving dcaps in %s and dskews in %s" capsName skewName;
  saveData dcaps  capsName;
  let tSavingDCaps  =  Some "-- saved dcaps timing: "  |> getTiming in
  saveData dskews skewName;
  let tSavingDSkews =  Some "-- saved dskews timing: " |> getTiming in
  saveData norms  normsName;
  let ts = List.rev (tSavingDSkews::tSavingDCaps::tSocRun@[tInvert]@tLoad) in
  printf "timings: %s\n" (show_float_list ts);
