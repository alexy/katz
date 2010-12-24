open Common
open Binary_graph

let () =
  let args = getArgs in
  match args with
    | dcapsName::restArgs -> 
      begin
        
      let dranksName = "dranks-" ^ dcapsName in
      let aranksName = "aranks-" ^ dcapsName in
      
      leprintfln "reading dcaps from %s, saving user ranks in %s, daily ranks in %s" 
        dcapsName dranksName aranksName;
    
      let dcaps: By_day.user_day_reals = loadData dcapsName in
      let (dranks, aranks) = Cranks.daranks dcaps in
      
      saveData dranks dranksName;
      saveData aranks aranksName
      
    end
      
    | _ -> failwith "usage: capsan dcapsName rankName"