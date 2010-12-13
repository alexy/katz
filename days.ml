open Batteries_uni
open Utils
open Printf (* sprintf *)
open Graph
open By_day
  
let () = 
  let args = getArgs in
  match args with
  | drepsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s, saving byday in %s" drepsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let (dreps,tLoad) = Load_graph.loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    let (byday: days) = by_day dreps in
    let tByday = Some "sliced dreps by day, timing: " |> getTiming in
    leprintfln "byday has length %d" (Array.length byday);
    leprintfln "now saving byday in %s" saveName;
    Binary_graph.saveData byday saveName;
    let tSaving =  Some "saved byday timing: " |> getTiming in
    let ts = List.rev (tSaving::tByday::tLoad) in
    printf "timings: %s\n" (show_float_list ts);
  end
  | _ -> leprintf "usage: sc drepsName bydayName"
