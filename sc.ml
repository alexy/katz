open Batteries_uni
open Utils
open Printf (* sprintf *)
open Graph
open Soc_run
open Invert

let suffix = String.ends_with

let loadAnyGraph : string -> (graph * timings) =
  fun fileName ->
    if suffix fileName "mlb" then
      let g = Binary_graph.loadData fileName in
      let t = Some (sprintf "loaded binary %s timing: " fileName) |> getTiming in
      (g,[t])
    else
    if suffix fileName "json.hdb" then
      let g = Tokyo_graph.fetchGraph fileName None (Some 10000) in
      let t = Some (sprintf "loaded json %s timing: " fileName) |> getTiming in
      (g,[t])
    else failwith "unrecognized graph file extension" 
  
let () = 
  let args = getArgs in
  match args with
  | drepsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s, saving dcaps in %s" drepsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let (dreps,tLoad) = loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    let dments = invert2 dreps in
    let tInvert = Some "inverted dreps into dments, timing: " |> getTiming in
    leprintfln "dments has length %d" (H.length dments);
    let ({dcapsSG =dcaps},tSocRun) = socRun dreps dments {optSocRun with maxDaysSR= maxDays} in
    leprintfln "computed sgraph, now saving dcaps in %s" saveName;
    Binary_graph.saveData dcaps saveName;
    let tSaving =  Some "saved dcaps timing: " |> getTiming in
    let ts = List.rev (tSaving::tSocRun@[tInvert]@tLoad) in
    printf "timings: %s\n" (show_float_list ts);
  end
  | _ -> leprintf "usage: sc drepsName dcapsName"
