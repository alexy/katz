open Common

(* TODO unify all three,
  dosim 
  dosimf
  dosimu
  with a getopt parser, since Simulate.simulate is all-in-one *)
  
let () =
  let uniform = true in
  let args = getArgs in
  match args with
    | dstartsName::denumsName::erepsName::restArgs -> 
      begin
      leprintfln "reading dstarts from %s and dnums from %s, saving uniform ereps in %s" 
        dstartsName denumsName erepsName;
    
      let dstarts: Dranges.starts     = loadData dstartsName in
      let denums: By_day.day_edgenums = loadData denumsName in

      let ereps = 
        match restArgs with
        | [] -> 
          Simulate.simulate ~uniform dstarts denums
        | drepsName::day'::[] -> begin
          let day = int_of_string day' in
          leprintfln "based on %s through day %d" drepsName day;
          let dreps: graph = loadData drepsName in
          (* inverting is much slower than loading dments.mlb...
             leprintfln "inverting...";
             let dments = Invert.invert2 dreps in *)
          let dreps_day = (dreps,day) in
          Simulate.simulate ~dreps_day ~uniform dstarts denums
        end
        | _ -> failwith "dreps usage: dosim dstartsName denumsName erepsName drepsName day"
      in saveData ereps erepsName
      end
  | _ -> failwith "usage: dosim dstartsName dnumsName erepsName [drepsName day]"
