(* compute how much relative talk volume
   each class bucket pushes *)
   
open Common
open Getopt

let mark'    = ref ""
let prefix'  = ref "rbucks"
let outdir'  = ref (Some !prefix')
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

  let aranksName,outdir =
  match args with
    | aranksName::outdir::restArgs -> aranksName, Some outdir
    | aranksName::restArgs         -> aranksName, outdir
    | _ -> failwith "usage: save_rbucks aranksName [outdir]"      
  in  

  let baseName = cutPathZ aranksName in
  let bucksName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  leprintfln "reading aranks from %s, saving buckets in %s" 
    aranksName bucksName;

  let aranks: day_rank_users = loadData aranksName in
  let bucks: day_buckets = A.map Topsets.buckets aranks in
  
  mayMkDir outdir;
  saveData bucks bucksName
