open Batteries_uni
open Utils
open Graph
open Soc_run

let suffix = String.ends_with

let loadAnyGraph : string -> graph =
  fun fileName ->
    if suffix fileName "mlb" then
      Binary_graph.loadData fileName
    else
    if suffix fileName "json.hdb" then
      Tokyo_graph.fetchGraph fileName None (Some 10000)
    else failwith "unrecognized graph file extension" 
  
let () = 
  let args = getArgs in
  match args with
  | drepsName::dmentsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s and %s, saving dcaps in %s" drepsName dmentsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let dreps = loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    let dments = loadAnyGraph dmentsName in
    leprintfln "loaded %s, %d" dmentsName (H.length dments);
    
    let {dcapsSG =dcaps} = socRun dreps dments {optSocRun with maxDaysSR= maxDays} in
    leprintfln "computed sgraph, now saving dcaps in %s" saveName;
    Binary_graph.saveData dcaps saveName
  end
  | _ -> leprintf "usage: sc dreps dments save-to"