open Common

let () =
  let args = getArgs in
  match args with
    | dcapsName::rankName::restArgs -> 
      begin
      leprintfln "reading dcaps from %s, saving ranked ones in %s" 
        dcapsName tokyoName;
    
      let dcaps: By_day.user_day_reals = loadData dcapsName in
      let dranks = Cranks.dranks dcaps in
      
      saveData dranks rankName
      
    end
      
    | _ -> failwith "usage: capsan dcapsName rankName"