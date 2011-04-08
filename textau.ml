open Common
open Getopt

let take'    = ref (Some 33)
let drop'    = ref (Some 7)
let precise' = ref false
let tostdout'= ref false
let outdir'  = ref (Some "txt")
let tex'     = ref false
let oneLine' = ref true

let specs =
[
  ('n',      "takedays",None,Some (fun x -> take' := Some (int_of_string x)));
  (noshort,"notakedays",(set take' None),None);
  ('d',      "dropdays",None,Some (fun x -> drop' := Some (int_of_string x)));
  (noshort,"nodropdays",(set drop' None),None);
	('p',"precise",(set precise' true), None);
	(noshort,"imprecise",(set precise' false), None);
	('c',"stdout", (set tostdout' (not !tostdout')),None);
  ('o',"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  ('t',"tex",(set tex' (not !tex')),None);
  ('1',"line",(set oneLine' (not !oneLine')), None);
]

let () =
	let args = getOptArgs specs in
	
	let precise,   take,   drop,   tostdout,   outdir =
			!precise', !take', !drop', !tostdout', !outdir' in
			
	let tex,   oneLine =
	    !tex', !oneLine' in

	let outdir = if tostdout then None else outdir in
		
	let dataName =
	match args with 
	| name::restArgs -> name
	| _ -> failwith "usage: textau tauname"
	in
	
	let first = 
	match dataName with
	| RE "cstau-skew-" (_* as name) ".mlb" -> name
	| _ -> failwith "have to have the simulation name"
	in
	
	let taus: day_taus = loadData dataName in
	let taus = arrayRange taus ~take ~drop in

	mayMkDir outdir;
	
	let oc = if tostdout then stdout
	else begin
		let saveName = dropText ".mlb" dataName |> 
			flip (^) ".txt" |> mayPrependDir outdir in
		leprintfln "saving result in %s\n" saveName;
		open_out saveName
	end in
	
	let floatPrint = 
		if precise 
			then TeX.preciseFloatPrint 
			else TeX.floatPrint in
		
	let sep,last = 
	match tex with
	| true -> " & ","\\\\\n"
	| _    -> "\t","\n"
	in
	
	if oneLine then
		A.print ~first ~sep ~last floatPrint oc taus
	else begin
		A.iter begin fun tau ->
			floatPrint oc tau;
			newline oc
		end taus;
	end;
	
	if tostdout then () else close_out oc
