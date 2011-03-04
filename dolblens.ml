open Common
open Getopt

let mark'   = ref ""
let prefix' = ref "le"
let outdir' = ref (Some "lblens")
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
    
  let bucksName,outdir =
  match args with
    | bucksName::outdir::restArgs -> bucksName,Some outdir
    | bucksName::restArgs ->         bucksName,outdir
    | _ -> failwith "usage: dolblens bucksName [outdir]"      
  in  

  let baseName = cutPath bucksName in
  let lensName = sprintf "%s%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading buckets from %s, saving lengths in %s" 
    bucksName lensName;

  let bucks:  day_log_buckets = loadData bucksName in
  let lens =  Dcaps.bucket_lens bucks in
  
  mayMkDir outdir;
  saveData lens lensName
