open Common
open Binary_graph

let () =
  let args = getArgs in
  match args with
    | dcapsName::rankName::restArgs -> 
      begin
      leprintfln "reading dcaps from %s, saving ranked ones in %s" 
        dcapsName rankName;
    
      let dcaps: By_day.user_day_reals = loadData dcapsName in
      let aranks = Cranks.aranks dcaps in
      
      saveData aranks rankName
      
    end
      
    | _ -> failwith "usage: capsan dcapsName rankName"