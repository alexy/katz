open Common
open Getopt

let minDays' = ref (Some 7)
let minCap'  = ref 1e-35
let mark'    = ref ""
let prefix'  = ref "cstau"
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

  let dcapsName,dskewsName,outdir =
  match args with
    | dcapsName::dskewsName::outdir::restArgs -> dcapsName,dskewsName,Some outdir
    | dcapsName::dskewsName::restArgs ->         dcapsName,dskewsName,outdir
    | _ -> failwith "usage: doska dcapsName dskewsName [outdir]"      
  in        

  let baseName = cutPathZ dskewsName in
  let saveName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  
  leprintfln "reading dcaps from %s, dskews from %s, saving Kentall's taus between them in %s" 
    dcapsName dskewsName saveName;
    
  let dcaps:   user_day_reals = loadData dcapsName in
  let dskews:  dskews         = loadData dskewsName in
  
  let cstau :  float array = Skew.kendall_tau dcaps dskews in
  
  mayMkDir outdir;
  saveData cstau saveName
