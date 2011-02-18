open Common

let () =
  let args = getArgs in
  let maturityDef = 7 in (* days *)
  let minimumDef  = 1e-35 in 
  let (dcapsName,maturity,minimum) =
  match args with
    | dcapsName::matS::minS::restArgs -> 
      (dcapsName, int_of_string matS, float_of_string minS)
    | dcapsName::matS::restArgs ->
      (dcapsName, int_of_string matS, minimumDef)
    | dcapsName::restArgs ->
      (dcapsName, maturityDef, minimumDef)
    | _ -> failwith "usage: docranks dcapsName [maturity minimum]"    
  in        
    let aranksName = "aranks-" ^ dcapsName in
    
    leprintfln "reading dcaps from %s, saving daily ranks (aranks) in %s" 
      dcapsName aranksName;
    leprintfln "any social capital with maturity less than %d days becomes %e" 
      maturity minimum;
      
    let dcaps: user_day_reals   = loadData dcapsName in
    let aranks : day_rank_users = Cranks.aranks maturity minimum dcaps in
    
    saveData aranks aranksName
