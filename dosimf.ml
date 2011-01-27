open Common

let () =
  let args = getArgs in
  match args with
    | duvalsName::dstartsName::denumsName::erepsName::restArgs -> 
      begin
      leprintfln "reading duvals from %s, dstarts from %s and dnums from %s, saving floating ereps in %s" 
        duvalsName dstartsName denumsName erepsName;
    
      (* user_day_reals <=> Soc_run.dCaps *)
      let udvals:  user_day_reals = loadData duvalsName in
      let dstarts: starts         = loadData dstartsName in
      let denums:  day_edgenums   = loadData denumsName in

      let duvals = By_day.dayUserReals udvals in
      
      let ereps = 
        match restArgs with
        | [] -> 
          Simulate.simulate ~duvals dstarts denums
        | drepsName::day'::[] -> begin
          let day = int_of_string day' in
          leprintfln "based on %s through day %d" drepsName day;
          let dreps: graph = loadData drepsName in
          (* inverting is much slower than loading dments.mlb...
             leprintfln "inverting...";
             let dments = Invert.invert2 dreps in *)
          let dreps_day = (dreps,day) in
          Simulate.simulate ~dreps_day dstarts denums ~duvals
        end
        | _ -> failwith "dreps usage: dosim dstartsName denumsName erepsName drepsName day"
      in saveData ereps erepsName
      end
  | _ -> failwith "usage: dosim dstartsName dnumsName erepsName [drepsName day]"
