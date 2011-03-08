open Common
open Getopt

let minDays' = ref (Some 7)
let minCap'  = ref 1e-35
let mark'    = ref ""
let prefix'  = ref "aranks"
let outdir'  = ref (Some !prefix')
let specs =
[
  (noshort,"prefix",None,Some (fun x -> prefix' := x));
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  ('d',"mindays",None,Some (fun x -> minDays' := Some (int_of_string x)));
  (noshort,"nomindays",(set minDays' None), None);
  ('c',"mincap",None,Some (fun x -> minCap' := float_of_string x));
  ('k',"mark",None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in

  let minDays,   minCap =
      !minDays', !minCap' in
  
  let prefix, outdir, mark =
      !prefix', !outdir', !mark' in

  let dcapsName,outdir =
  match args with
    | dcapsName::outdir::restArgs -> dcapsName,Some outdir
    | dcapsName::restArgs ->         dcapsName,outdir
    | _ -> failwith "usage: doaranks dcapsName [outdir]"      
  in        

  let baseName = cutPath dcapsName in
  let aranksName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  
  leprintfln "reading dcaps from %s, saving daily ranks (aranks) in %s" 
    dcapsName aranksName;
  begin match minDays with
  | Some minDays -> leprintfln "applying minCap %e for maturities less than %d days" minCap minDays
  | _ -> leprintfln "not using maturity at all" 
  end;
    
  let dcaps: user_day_reals   = loadData dcapsName in
  let aranks : day_rank_users = Cranks.aranks (Option.default 0 minDays) minCap dcaps in
  
  mayMkDir outdir;
  saveData aranks aranksName
