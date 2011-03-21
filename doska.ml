open Common
open Getopt

let length'  = ref true
let minDays' = ref (Some 7)
let minCap'  = ref 1e-35
let mark'    = ref ""
let prefix'  = ref "cstau"
let outdir'  = ref (Some !prefix')
let specs =
[
	('l',"length",(set length' (not !length')),None);
  (noshort,"prefix",None,Some (fun x -> prefix' := x));
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  ('k',"mark",None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in

  let prefix, outdir, mark =
      !prefix', !outdir', !mark' in

  let length,   minDays,   minCap =
      !length', !minDays', !minCap' in

  let dcapsName,dskewsName,outdir =
  match args with
    | dcapsName::dskewsName::outdir::restArgs -> dcapsName,dskewsName,Some outdir
    | dcapsName::dskewsName::restArgs ->         dcapsName,dskewsName,outdir
    | _ -> failwith "usage: doska dcapsName dskewsName [outdir]"      
  in        

  let baseName = cutPathZ dskewsName in
  let saveName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  
  leprintfln "reading dcaps from %s, dskews from %s, saving Kendall's Tau between their days in %s" 
    dcapsName dskewsName saveName;
    
  let dcaps:   user_day_reals = loadData dcapsName in
  
  let sort = true in
  let day_user_caps = 
  match minDays with
  | Some md -> begin
  		leprintfln "maturizing capitals younger than %d days to %e"  md minCap;
			Dcaps.mature_day_user_caps md minCap ~sort dcaps
  	end
  | _ -> Skew.day_user_caps ~sort dcaps in
  
  let dskews:  dskews         = loadData dskewsName in
  let cstau :  float array = Skew_c.kendall_tau_days ~length day_user_caps dskews in
  
  mayMkDir outdir;
  saveData cstau saveName
