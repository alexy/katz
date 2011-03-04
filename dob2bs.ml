(* compute, for each bucket, 
   how many tweets are placed to each other bucket that day *)
   
open Common
open Getopt

(* here we expect mark either r, by replies, or m, by mentions *)
let mark'   = ref "r"
let invert' = ref false
let prefix' = ref "b2b"
let outdir' = ref (Some !prefix')
let specs =
[
  (noshort,"prefix",None,Some (fun x -> prefix' := x));
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  ('k',"mark",None,Some (fun x -> mark' := x));
  ('i',"invert",(set invert' (not !invert')),None)
]

let () =
  let args = getOptArgs specs in
  
  let mark,   invert = 
      !mark', !invert' in

  let prefix, outdir =
      !prefix', !outdir' in
  let outdir = optAppend outdir mark in
  
  let drepsName,bucksName,outdir =
  match args with
    | drepsName::bucksName::outdir::restArgs -> drepsName,bucksName,Some outdir
    | drepsName::bucksName::restArgs         -> drepsName,bucksName,outdir
    | _ -> failwith "usage: dob2bs drepsName bucksName [outdir]"      
  in  

  let baseName = cutPath bucksName in
  let b2bName = sprintf "%s%s-%s" prefix mark baseName |> mayPrependDir outdir in

  let dreps: graph = let g: graph = loadData drepsName in
    if invert then Invert.invert2 g 
              else g in
  let bucks: day_buckets = loadData bucksName in

  let b2bs: day_b2b = Bucket_power.b2b dreps bucks in
  
  mayMkDir outdir;
  saveData b2bs b2bName
  