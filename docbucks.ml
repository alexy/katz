open Common
open Getopt

let mark'   = ref ""
let prefix' = ref "lb"
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
    
  let jcapsName =
  match args with
    | jcapsName::restArgs -> jcapsName
    | _ -> failwith "usage: dobucks jcapsName"      
  in  

  let baseName = cutPath jcapsName in
  let bucksName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading jcaps from %s, saving buckets in %s" 
    jcapsName bucksName;

  let jcaps:  day_caps = loadData jcapsName in
  let bucks = A.map Dcaps.bucketize2 jcaps in
  
  saveData bucks bucksName
