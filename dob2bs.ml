(* compute, for each bucket, 
   how many tweets are placed to each other bucket that day *)
   
open Common

let () =
  let args = getArgs in
  let drepsName,bucksName =
  match args with
    | drepsName::bucksName::restArgs -> drepsName,bucksName
    | _ -> failwith "usage: dob2bs drepsName bucksName"      
  in  

  let b2bName = "b2b-"^bucksName in

  let dreps: graph        = loadData drepsName in
  let bucks: day_buckets  = loadData bucksName in

  let b2b = Bucket_power.b2b dreps bucks in
  
  saveData b2b b2bName
