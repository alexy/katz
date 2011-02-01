open Common

let () =
  let args = getArgs in
  match args with
    | dstartsName::denumsName::erepsName::restArgs -> 
      begin
      leprintfln "reading dstarts from %s and dnums from %s, saving ereps in %s" 
        dstartsName denumsName erepsName;
    
      let dstarts: starts       = loadData dstartsName in
      let denums:  day_edgenums = loadData denumsName in

      let ereps: graph = 
        match restArgs with
        | [] -> 
          Simulate.simulate dstarts denums
        | drepsName::day'::[] -> begin
          let day = int_of_string day' in
          leprintfln "based on %s through day %d" drepsName day;
          let dreps: graph = loadData drepsName in
          (* inverting is much slower than loading dments.mlb...
             leprintfln "inverting...";
             let dments = Invert.invert2 dreps in *)
          let dreps_day = (dreps,day) in
          Simulate.simulate ~dreps_day dstarts denums
        end
        | _ -> failwith "dreps usage: dosim dstartsName denumsName erepsName drepsName day"
      in saveData ereps erepsName
      end
  | _ -> failwith "usage: dosim dstartsName dnumsName erepsName [drepsName day]"
