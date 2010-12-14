open Batteries_uni
open Utils
open Printf (* sprintf *)
open Graph
  
let () = 
  let args = getArgs in
  match args with
  | drepsName::saveName::restArgs -> begin
    leprintfln "reading graph from %s, saving dstarts in %s" drepsName saveName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let (dreps,tLoad) = Load_graph.loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    
    let dments = Invert.invert2 dreps in
    let tInvert = Some "inverted dreps into dments, timing: " |> getTiming in
    leprintfln "dments has length %d" (H.length dments);  
      
    let (dstarts,(firstDay,lastDay)) = Dranges.startsRange dreps dments in
    let tStarts = Some "computed dstarts, timing: " |> getTiming in
    leprintfln "dstarts has length %d, firstDay %d, lastDay %d" (H.length dstarts) firstDay lastDay;
    leprintfln "now saving byday in %s" saveName;
    Binary_graph.saveData dstarts saveName;
    let tSaving =  Some "saved byday timing: " |> getTiming in
    let ts = List.rev (tSaving::tStarts::tInvert::tLoad) in
    printf "timings: %s\n" (show_float_list ts);
  end
  | _ -> leprintf "usage: save_starts drepsName dstartsName"
