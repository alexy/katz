open Common
open By_day
  
let () = 
  let args = getArgs in
  match args with
  | drepsName::edgeName::numsName::restArgs -> begin
    leprintfln "reading graph from %s, saving byday edges in %s and edge nums in %s" drepsName edgeName numsName;
    let maxDays = restArgs |> List.map int_of_string |> option_of_list in
    let (dreps,tLoad) = Load_graph.loadAnyGraph drepsName in
    leprintfln "loaded %s, %d" drepsName (H.length dreps);
    
    let (byday: days) = by_day dreps in
    let tByday = Some "sliced dreps by day, timing: " |> getTiming in
    leprintfln "byday has length %d" (Array.length byday);

    leprintfln "now saving byday in %s" edgeName;
    Binary_graph.saveData byday edgeName;
    let tEdge =  Some "saved byday timing: " |> getTiming in
    
    let nums : day_edgenums = dayEdgenums byday in
    leprintfln "now saving nums in %s" numsName;
    Binary_graph.saveData nums numsName;
    let tNums =  Some "computed and saved nums timing: " |> getTiming in
    
    let ts = List.rev (tNums::tEdge::tByday::tLoad) in
    printf "timings: %s\n" (show_float_list ts);
  end
  | _ -> leprintf "usage: save_days drepsName bydayName"
