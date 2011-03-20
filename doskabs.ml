open Common
open Getopt

let minDays' = ref (Some 7)
let minCap'  = ref 1e-35
let mark'    = ref ""
let prefix'  = ref "cstaubs"
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

  let minDays,   minCap =
      !minDays', !minCap' in

  let dcapsName,dskewsName,rbucksName,outdir =
  match args with
    | dcapsName::dskewsName::rbucksName::outdir::restArgs -> dcapsName,dskewsName,rbucksName,Some outdir
    | dcapsName::dskewsName::rbucksName::restArgs ->         dcapsName,dskewsName,rbucksName,outdir
    | _ -> failwith "usage: doskabs dcapsName dskewsName rbucksName [outdir]"      
  in        

  let baseName = cutPathZ dskewsName in
  let saveName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  
  leprintfln "reading dcaps from %s, dskews from %s, rbucks from %s,\nsaving Kendall's Tau per day-buckets in %s" 
    dcapsName dskewsName rbucksName saveName;
    
  let dcaps: user_day_reals = loadData dcapsName in
  
  let day_user_caps = 
  match minDays with
  | Some md -> begin
  		leprintfln "maturizing capitals younger than %d days to %e"  md minCap;
			Dcaps.mature_day_user_caps md minCap ~sort:false dcaps
  	end
  | _ -> Skew.day_user_caps ~sort:false dcaps in
  
  let dskews:   dskews        = loadData dskewsName in
  let rbucks:   rbucks        = loadData rbucksName in
  let cstaubs:  day_tau_bucks = Skew_c.kendall_tau_bucks day_user_caps dskews rbucks in
  
  mayMkDir outdir;
  saveData cstaubs saveName
