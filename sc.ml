open Batteries_uni
open Utils
open Printf (* sprintf *)
open Graph
open Soc_run

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
  | drepsName::dmentsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s and %s, saving dcaps in %s" drepsName dmentsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let (dreps,t0) = loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    let (dments,t1) = loadAnyGraph dmentsName in
    leprintfln "loaded %s, %d" dmentsName (H.length dments);
    let ({dcapsSG =dcaps},t2) = socRun dreps dments {optSocRun with maxDaysSR= maxDays} in
    leprintfln "computed sgraph, now saving dcaps in %s" saveName;
    Binary_graph.saveData dcaps saveName;
    let t3 =  Some "saved dcaps timing: " |> getTiming in
    let ts = List.rev (t3::t2@t1@t0) in
    printf "timings: %s\n" (show_float_list ts);
  end
  | _ -> leprintf "usage: sc dreps dments save-to"