(* compute, for each bucket, 
   how many tweets are placed to each other bucket that day *)
   
open Common
open Getopt

(* here we expect mark either r, by replies, or m, by mentions *)
let mark' = ref "r"
let specs =
[
  ('k',"mark",None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in
  
  let mark = !mark' in

  let drepsName,bucksName =
  match args with
    | drepsName::bucksName::restArgs -> drepsName,bucksName
    | _ -> failwith "usage: dob2bs drepsName bucksName"      
  in  

  let b2bName = sprintf "b2b%s-%s" mark bucksName in

  let dreps: graph        = loadData drepsName in
  let bucks: day_buckets  = loadData bucksName in

  let b2bs: day_b2b = Bucket_power.b2b dreps bucks in
  
  saveData b2bs b2bName
