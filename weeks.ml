open Common
open Getopt

let simsN = 250

let tostdout' = ref false
let outdir'   = ref (Some "weeks")
let specs =
[
	('c',"stdout", (set tostdout' (not !tostdout')),None);
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None)
]

  
let () =
	let args = getOptArgs specs in
	
	let tostdout,   outdir =
			!tostdout', !outdir' in

	let outdir = if tostdout then None else outdir in

	let dataFileName =
	match args with
	| name::restArgs -> name
	| _ -> failwith "usage: dataframe filename"
	in

	mayMkDir outdir;

	let oc = if tostdout then stdout
	else begin
		let saveName = dropText ".txt" dataFileName |> 
			flip (^) ".r.txt" |> mayPrependDir outdir in
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
  		  | RE ( _* as base ) ( [ '0' - '4' ] as week' ) "wk"? Lazy eol ->
  		    let week = int_of_string week' in (* how do we create week as int? *)
    			if week < !minWeek then minWeek := week;
    			if week > !minWeek then maxWeek := week;
    		  (base,week,vs)
  		  end
  		| _ -> failwith 
  			(sprintf "ERROR: malformed line in %s: %s" dataFileName line)
  	end (File.lines_of dataFileName) in
  	
  (* E.clone rows |> E.map (fun (x,y,z) -> (x,y)) |> 
  E.print (Pair.print String.print Int.print) stderr; *)
  E.force rows;
  
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
    let rs = L.map snd wrs in
    let ld = list_delta rs in
    let d = try L.last rs with Invalid_argument("Empty List") -> 1000 in
    base,d,ld
  end |> Array.of_list in
  
  A.sort begin fun (_,d1,ld1) (_,d2,ld2) ->
    match compare ld1 ld2 with
    | 0 -> compare d1 d2
    | x -> x 
  end rankd;
  
  let triple_print oc (x,y,z) = fprintf oc "%s %d %d" x y z in
  
  A.print ~first:"" ~sep:"\n" ~last:"\n" triple_print oc rankd