open Common
open Getopt

let mark'   = ref ""
let prefix' = ref "rblens"
let outdir' = ref (Some !prefix')
let specs =
[
  (noshort,"prefix",None,Some (fun x -> prefix' := x));
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  ('k',"mark",None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in
  
  let prefix, outdir, mark =
      !prefix', !outdir', !mark' in

  let bucksName =
  match args with
    | bucksName::restArgs -> bucksName
    | _ -> failwith "usage: dobuckles bucksName"      
  in  

  let baseName = cutPath bucksName in
  let lensName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading buckets from %s, saving lengths in %s" 
    bucksName lensName;

  let bucks: day_buckets = loadData bucksName in
  let lens: int_rates    = Bucket_power.bucket_lens bucks in
  
  saveData lens lensName
