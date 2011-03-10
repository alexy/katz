open Common
open Getopt

let mark'   = ref ""
let prefix' = ref "lb"
let outdir' = ref (Some "lbucks")
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
    
  let jcapsName,outdir =
  match args with
    | jcapsName::outdir::restArgs -> jcapsName,Some outdir
    | jcapsName::restArgs         -> jcapsName,outdir
    | _ -> failwith "usage: dobucks jcapsName [outdir]"      
  in  

  let baseName = cutPathZ jcapsName in
  let bucksName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading jcaps from %s, saving buckets in %s" 
    jcapsName bucksName;

  let jcaps:  day_caps = loadData jcapsName in
  let bucks = A.map Dcaps.bucketize2 jcaps in
  
  mayMkDir outdir;
  saveData bucks bucksName
