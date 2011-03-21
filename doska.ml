open Common
open Getopt

let buckets' = ref false
let length'  = ref true
let minDays' = ref (Some 7)
let minCap'  = ref 1e-35
let mark'    = ref ""
let prefix'  = ref "cstau"
let outdir'  = ref (Some !prefix')
let bucketSuffix = "bs"
let specs =
[
	('b',"buckets",(set buckets' (not !buckets')),None);	
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

  let buckets,   length,   minDays,   minCap =
      !buckets', !length', !minDays', !minCap' in

  let prefix,outdir = 
  	if buckets 
  		then prefix^bucketSuffix, optAppend outdir bucketSuffix
  		else prefix, outdir in


  let dcapsName,dskewsName,rbucksName,outdir =
  if buckets then  
		match args with
			| dcapsName::dskewsName::rbucksName::outdir::restArgs -> dcapsName,dskewsName,rbucksName,Some outdir
			| dcapsName::dskewsName::rbucksName::restArgs ->         dcapsName,dskewsName,rbucksName,outdir
			| _ -> failwith "usage: doska --buckets dcapsName dskewsName rbucksName [outdir]"      
	else
		match args with
			| dcapsName::dskewsName::outdir::restArgs -> dcapsName,dskewsName,"",Some outdir
			| dcapsName::dskewsName::restArgs ->         dcapsName,dskewsName,"",outdir
			| _ -> failwith "usage: doska dcapsName dskewsName [outdir]"      
  in
  

  let baseName = cutPathZ dskewsName in
  let saveName = sprintf "%s-%s%s" prefix mark baseName |> mayPrependDir outdir in
  
  leprintfln begin "reading dcaps from %s, dskews from %s%s,\n"^^
  						"saving Kendall's Tau per day, %s, in %s,\n"^^
  						"%susing length in compareSkew" end
    dcapsName dskewsName 
    (if buckets then sprintf ", rbucks from %s" rbucksName else "")
    (if buckets then "per bucket" else "whole")
    saveName 
    (if length then "" else "not ");

  let dcaps:   user_day_reals = loadData dcapsName in
  
  let sort = not buckets in
  let day_user_caps = 
  match minDays with
  | Some md -> begin
  		leprintfln "maturizing capitals younger than %d days to %e"  md minCap;
			Dcaps.mature_day_user_caps md minCap ~sort dcaps
  	end
  | _ -> Skew.day_user_caps ~sort dcaps in
  
  let dskews:  dskews         = loadData dskewsName in

  mayMkDir outdir;

  if buckets then
	  let rbucks:   rbucks      = loadData rbucksName in
	  let cstaubs:  day_tau_bucks = 
	  Skew_c.kendall_tau_bucks ~length day_user_caps dskews rbucks in
		saveData cstaubs saveName
	else		
	  let cstau: day_taus = 
	  Skew_c.kendall_tau_days ~length day_user_caps dskews in
    saveData cstau saveName
