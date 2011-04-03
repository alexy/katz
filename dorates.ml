open Common
open Getopt

(* srates stand for staying rates *)

let prefix' = ref "srates"
let outdir' = ref (Some !prefix')
let mark'   = ref ""
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
    | _ -> failwith "usage: dorates bucksName [outdir]"      
  in  

  let baseName = cutPathZ bucksName in
  let saveName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading bucks from %s, saving rates in %s" 
    bucksName saveName;

  let bucks: day_buckets = loadData bucksName in

  let rates: rates = Topsets.bucketDynamics bucks in
  le_newline;
  
  Topsets.show_rates rates;
  
  mayMkDir outdir;
  saveData rates saveName
