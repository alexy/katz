open Common
open Getopt

let uniform'       = ref false
let duvalsNameOpt' = ref None

let specs =
[
  ('u',"uniform",(set uniform' (not !uniform')), None);
  ('c',"duvals",None,Some (fun x -> duvalsNameOpt' := Some x));
  ('r',"rand",None,Some (fun x -> randInit (int_of_string x)))
]

let () =
  let args = getOptArgs specs in
  
  let uniform,   duvalsNameOpt =
      !uniform', !duvalsNameOpt' in
  
  let dstartsName,denumsName,erepsName,restArgs =
  match args with
    | dstartsName::denumsName::erepsName::restArgs -> 
      dstartsName,denumsName,erepsName,restArgs
    | _ -> failwith "usage: sim dstartsName dnumsName erepsName [drepsName day]"
  in
  
  let simKind = match uniform,duvalsNameOpt with
  | true,_ -> "uniform"
  | _,Some _ -> "preduvalued"
  | _ -> "mentions-based"
  in
  leprintfln "reading dstarts from %s and dnums from %s, saving %s ereps in %s" 
    dstartsName denumsName simKind erepsName;

  let dstarts: starts       = loadData dstartsName in
  let denums:  day_edgenums = loadData denumsName in

  let duvalsOpt = 
  match duvalsNameOpt with
  | Some fileName ->
    let udvals: user_day_reals = loadData fileName in
    let duvals = By_day.dayUserReals udvals in
    Some duvals
  | _ -> None in

  let ereps: graph = 
    match restArgs with
    | [] ->
      begin
      if uniform then 
        Simulate.simulate ~uniform dstarts denums
      else match duvalsOpt with
      | Some duvals ->
        Simulate.simulate ~duvals dstarts denums
      | _ ->
        Simulate.simulate dstarts denums
      end
    | drepsName::day'::[] -> begin
      let day = int_of_string day' in
      leprintfln "based on %s through day %d" drepsName day;
      let dreps: graph = loadData drepsName in
      let dreps_day = (dreps,day) in
      if uniform then 
        Simulate.simulate ~dreps_day ~uniform dstarts denums
      else match duvalsOpt with
      | Some duvals ->
        Simulate.simulate ~dreps_day ~duvals dstarts denums
      | _ ->
        Simulate.simulate ~dreps_day dstarts denums
      end
    | _ -> failwith "dreps usage: sim dstartsName denumsName erepsName drepsName day"
  in 
  saveData ereps erepsName
