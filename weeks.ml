open Common
open Getopt

let simsN     = 250
let bucketsN  = 7

let tostdout'  = ref false
let outdir'    = ref (Some "weeks")
let addDreps'  = ref false
let addVals'   = ref 1.0
let showJumps' = ref false
let infix'     = ref None

let specs =
[
	('c',"stdout",      (set tostdout' (not !tostdout')), None);
  (noshort,"outdir",  None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir",   (set outdir' None),     None);
  ('d',"dreps",       (set addDreps' true),   None);
  (noshort,"nodreps", (set addDreps' false),  None);
  ('x',"val",         None, Some (fun x -> addVals' := float_of_string x));
  ('j',"jumps",       (set showJumps' true),  None);
  (noshort,"nojumps", (set showJumps' false), None);
  ('i',"infix", None, Some (fun x -> infix' := Some x));
  ('i',"noinfix",     (set infix' None),      None)
]


let makeSuffix infix showJumps =
  let infix = match infix with
  | Some i -> i
  | None when showJumps -> "j"
  | _ -> "r" in
  sprintf ".%s.txt" infix

  
let () =
	let args = getOptArgs specs in
	
	let tostdout,   outdir,   addDreps,   addVals,   showJumps,   infix =
			!tostdout', !outdir', !addDreps', !addVals', !showJumps', !infix' in

	let outdir = if tostdout then None else outdir in

	let dataFileName =
	match args with
	| name::restArgs -> name
	| _ -> failwith "usage: dataframe filename"
	in

	mayMkDir outdir;

	let oc = if tostdout then stdout
	else begin
	  let suffix = makeSuffix infix showJumps in
		let saveName = dropText ".txt" dataFileName |> 
			flip (^) suffix |> mayPrependDir outdir in
		leprintfln "saving result in %s\n" saveName;
		open_out saveName
	end in
		
	let minWeek = ref 10
	and maxWeek = ref 0 in
	let rows = 
  	E.map begin fun line ->
  		match Pcre.split ~pat:"\\s+" line with
  		| h::t -> begin
  			let vs = L.map float_of_string t in
  		  match h with  
  		  | "dreps" -> (h,0,vs)
  		  | RE ( _* Lazy as base ) ("-" [ '0' - '3' ])? ( [ '0' - '4' ] as week' ) "wk"? Lazy eol ->
  		    let week = int_of_string week' in (* how do we create week as int? *)
    			if week < !minWeek then minWeek := week;
    			if week > !maxWeek then maxWeek := week;
    		  (base,week,vs)
  		  end
  		| _ -> failwith 
  			(sprintf "ERROR: malformed line in %s: %s" dataFileName line)
  	end (File.lines_of dataFileName) in
  	
  (* E.clone rows |> E.map (fun (x,y,z) -> (x,y)) |> 
  E.print (Pair.print String.print Int.print) stderr; *)
  E.force rows;
  (* ignore (E.peek rows); -- peeking is not enough, force is *)
  
  let rows = 
  if addDreps then
    let drepsVals = L.make bucketsN addVals in
    let drepsRow = ("dreps",0,drepsVals) in
    E.append (E.singleton drepsRow) rows
  else
    rows in
  
  let minWeek = !minWeek
  and maxWeek = !maxWeek in
  
  let weeksRange = E.range minWeek ~until:maxWeek |> L.of_enum in
  
  let weeks = H.create simsN in
  E.iter begin fun (base,week,vs) ->
    if base = "dreps" then
      weeksRange |> L.map (fun wk -> (wk, vs)) |> H.add weeks base
    else
      let ws = H.find_default weeks base [] in
      H.replace weeks base ((week,vs)::ws)
  end rows;
  
  printf "dreps's weeks length = %d\n" (L.length (weeks --> "dreps"));
  let drepsV = weeks --> "dreps" |> L.hd |> snd in

  let distances =
  L.map begin fun wk ->
    H.map (fun base ws -> L.Exceptionless.assoc wk ws) weeks |> 
    H.enum |> L.of_enum |>
    L.filter_map begin function 
      | (base,Some v) -> 
        let d = Mathy.euclidian_distance_list v drepsV in
        Some (base,d)
      | _ -> None
    end |>
    Array.of_list
  end weeksRange in
  
  L.iter (A.sort compPairAsc2) distances;
  
  let ranksH = H.create simsN in
  L.iteri begin fun wk a ->
    A.mapi begin fun r (base,_) ->
      let baseRanks = H.find_default ranksH base [] in
      H.replace ranksH base ((wk,r)::baseRanks)
    end a
  end distances;
  
  let rankd = list_of_hash ranksH |>
  L.map begin fun (base,wrs) ->
    let rs    = L.map snd wrs in
    let delta = list_delta rs in
    let diffs = list_diffs rs in
    let d = try L.last rs with Invalid_argument("Empty List") -> 1000 in
    base,d,delta,diffs
  end |> Array.of_list in
  
  A.sort begin fun (_,d1,delta1,_) (_,d2,delta2,_) ->
    match compare delta1 delta2 with
    | 0 -> compare d1 d2
    | x -> x 
  end rankd;
  
  let triple_print oc (x,y,z,_) = fprintf oc "%s %d %d" x y z in
  (* thelema: If you want to print a bunch of things to a single string, 
     use IO.output_string () to create your output; 
     to_string used for a single call here: *)
  let quadro_print oc (x,y,z,w) = fprintf oc "%s %d %d %s" x y z (((L.print Int.print) |> IO.to_string) w) in
  
  let row_print = if showJumps then quadro_print else triple_print in
  
  A.print ~first:"" ~sep:"\n" ~last:"\n" row_print oc rankd