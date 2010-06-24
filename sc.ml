open Batteries_uni
open Binary_graph
open Utils
open Graph
open Soc_run

let () = 
  let args = getArgs in
  match args with
  | drepsName::dmentsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s and %s, saving dcaps in %s" drepsName dmentsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let dreps : graph = loadData drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    let dments : graph = loadData dmentsName in
    leprintfln "loaded %s, %d" dmentsName (H.length dments);
    
    let {dcapsSG =dcaps} = socRun dreps dments {optSocRun with maxDaysSR= maxDays} in
    leprintfln "computed sgraph, now saving dcaps in %s" saveName;
    saveData dcaps saveName
  end
  | _ -> leprintf "usage: sc dreps dments save-to"