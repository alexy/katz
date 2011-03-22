open Common
open Getopt

let take'    = ref (Some 33)
let drop'    = ref (Some 7)
let precise' = ref true
let tostdout'= ref false
let outdir'  = ref (Some "txt")

let specs =
[
  ('t',      "takedays",None,Some (fun x -> take' := Some (int_of_string x)));
  (noshort,"notakedays",(set take' None),None);
  ('d',      "dropdays",None,Some (fun x -> drop' := Some (int_of_string x)));
  (noshort,"nodropdays",(set drop' None),None);
	('p',"precise",(set precise'  (not !precise')), None);
	('c',"stdout", (set tostdout' (not !tostdout')),None);
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None)
]

let () =
	let args = getOptArgs specs in
	
	let precise,   take,   drop,   tostdout,   outdir =
			!precise', !take', !drop', !tostdout', !outdir' in

	let outdir = if tostdout then None else outdir in
		
	let dataName =
	match args with 
	| name::restArgs -> name
	| _ -> failwith "usage: textau tauname"
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
		
	
	A.iter begin fun tau ->
		floatPrint oc tau;
		newline oc
	end taus;
	
	if tostdout then () else close_out oc
