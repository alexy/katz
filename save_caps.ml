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
    | _ -> failwith "usage: save_caps dcapsName [maturity minimum]"    
  in        
    (* j is for just caps *)
    let capsName = "j" ^ dcapsName in
    let sort = true in
    
    leprintfln "reading dcaps from %s, saving caps in %s" 
      dcapsName capsName;
      
    let dcaps: user_day_reals = loadData dcapsName in
    let caps: day_caps = Dcaps.mature_day_caps maturity minimum ~sort dcaps in
    
    saveData caps capsName;
