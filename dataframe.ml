open Common
open Getopt

let drepsName  = "dreps"

let tab = "\t"
let jumpPrint oc x = if x >= 0.1 then fprintf oc "%3.1f" x else fprintf oc "%4.2f" x
let preciseFloatPrint oc x = fprintf oc "%17.15f" x
let nBuckets = 7

let addDreps'  = ref false
let addVals'   = ref 1.0
let buckDists' = ref true
let tostdout'  = ref false
let outdir'    = ref (Some "df")
let specs =
[
  ('r',"dreps",       (set addDreps' true),   None);
  (noshort,"nodreps", (set addDreps' false),  None);
  ('x',"val",         None, Some (fun x -> addVals' := float_of_string x));
	('b',"buckdists",(set buckDists' (not !buckDists')),None);
	('c',"stdout", (set tostdout' (not !tostdout')),None);
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None)
]

let fullBucketRange = E.range 1 ~until:nBuckets |> L.of_enum
let fullBucketSet   = fullBucketRange |> L.enum |> IS.of_enum

(* let dreps = A.create nBuckets 1.0 *)

let string_array_of_buckets bs =
	let a = A.init nBuckets (fun i -> "F") in
	begin match bs with
	| Some buckets -> L.iter begin fun b ->
		a.(pred b) <- "T"
		end buckets
	| _ -> ()
	end;
	a

let get_buckets s =
	match s with
	 | RE _* "b" (digit+ as ds) ([ 't' 'f' ] as keep) ->
			let bs = String.enum ds |> E.map ord in
			let bs = 
			begin match keep with
			| "t" -> bs
			| "f" -> let s = IS.of_enum bs in
					let theRest = IS.diff fullBucketSet s in
					theRest |> IS.enum
			| _ -> failwith "impossible, t or f matched in mikmatch"
			end |> L.of_enum in			
				 Some bs
	| _ -> None
	
	
let get_week s =
	match s with
	| RE "dreps" -> 5
	| RE _* ([ '0'-'4' ] as wk) "wk"? Lazy eol ->
		int_of_string wk
	| _ -> failwith (sprintf "sim %s has no week" s)
	
	
type maturity = Regular | Medium | Fresh | Natural

let maturity_of_string s =
	match s with
	| "0d" -> Fresh
	| "7m" -> Medium
	| _    -> Regular
	
	
(* we want to use unique caps in the dataframe *)

let string_of_maturity mat =
	match mat with
	| Regular -> "R"
	| Medium  -> "E"
	| Fresh   -> "H"
	| Natural -> "-"
	
	
let get_maturity s =
	match s with
	| RE "dreps" -> Natural
	| RE _* ("0d" | "7m" as mat) digit+ "wk"? Lazy eol ->
		maturity_of_string mat
	| _ -> Regular

type strategy = Uniform | Mentions | Predefined | Capital | Nothing
type utility  = bool

RE strat_re = [ 'u' 'm' 'c' ]

let strategy_of_string s =
	match s with
	| "u" -> Uniform
	| "m" -> Mentions
	| "c" -> Capital
	| _   -> failwith (sprintf "no strategy for %s" s)
	
	
let string_of_strategy strat =
	match strat with
	| Uniform    -> "U"
	| Mentions   -> "M"
	| Predefined -> "P"
	| Capital    -> "C"
	| _          -> "-"
	
let get_strategy s =
	match s with
	| RE "dreps"   -> (Nothing,    Nothing, false)
	| RE "ureps" -> (Uniform,    Nothing, false)
	| RE "ereps" -> (Mentions,   Nothing, false)
	| RE "creps" -> (Predefined, Nothing, false)
	| RE "rreps" -> (Capital,    Nothing, false)
	| RE "lj" digit+ (strat_re as strat) -> 
			(strategy_of_string strat,Nothing,true)
	| RE "fg" digit+ (strat_re as global_strat) "f" digit+ (strat_re as fof_strat) ->
	    (strategy_of_string global_strat,
	     strategy_of_string fof_strat,true)
	| _ -> failwith (sprintf "weird sim %s" s)
			

let get_jumps s =
	let j2f s = float_of_string ("0."^s) in
	match s with
	| RE "lj" (digit+ as jumpUtil) -> 
		(j2f jumpUtil, 1.)
	| RE "fg" (digit+ as jumpUtil) strat_re "f" (digit+ as jumpFOF) -> 
		(j2f jumpUtil, j2f jumpFOF)
	| _ -> (1.,1.)
	
type row = { 
	nameROW           : string;
	globalStrategyROW : strategy;
	fofStrategyROW    : strategy;
	utilityROW        : bool;
	jumpsROW          : float * float;
	maturityROW       : maturity;
	weekROW           : int;
	bucketsROW        : int list option;
	vectorROW         : float list;
	distanceROW       : float;
	buckDistsROW      : float list
	}
	
let make_row name ?(buckDists=[]) ?(distance=nan) vs =
	let globalStrategy,fofStrategy,utility = get_strategy name in
	{ nameROW=           name;
	  globalStrategyROW= globalStrategy;
	  fofStrategyROW=    fofStrategy;
	  utilityROW=        utility;
	  maturityROW=       get_maturity name;
	  jumpsROW=          get_jumps name;
	  weekROW=           get_week name;
	  bucketsROW=        get_buckets name;
	  vectorROW=         vs;
	  buckDistsROW=      buckDists;
	  distanceROW=       distance
	}
	
let print_row oc ?(buckDists=false) r =
	let
	{ nameROW=           name;
	  globalStrategyROW= globalStrategy;
	  fofStrategyROW=    fofStrategy;
	  utilityROW=        utility;
	  maturityROW=       maturity;
	  jumpsROW=          jumps;
	  weekROW=           week;
	  bucketsROW=        buckets;
	  buckDistsROW=      bds;
	  distanceROW=       distance
	} = r in
		let sprint x = String.print oc x in
		let tab' () = sprint tab in
		sprint name;
		tab'();
		sprint (string_of_strategy globalStrategy);
		tab'();
		sprint (string_of_strategy fofStrategy);
		tab'();
		sprint (string_of_boolean utility);
		tab'();
		sprint (string_of_maturity maturity);
		tab'();
		let jumpUtil, jumpFOF = jumps in
		jumpPrint oc jumpUtil;
		tab'();
		jumpPrint oc jumpFOF;
		tab'();
		Int.print oc week;
		A.print ~first:tab ~sep:tab ~last:tab String.print oc 
			(string_array_of_buckets buckets);
		if buckDists then
			L.print ~first:"" ~sep:tab ~last:tab 
				preciseFloatPrint oc bds 	
		else ();
		preciseFloatPrint oc distance;
		newline oc
	

let () =
	let args = getOptArgs specs in
	
	let tostdout,   outdir =
			!tostdout', !outdir' in

	let addDreps,   addVals,   buckDists =
	 		!addDreps', !addVals', !buckDists' in
	
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
	
	let lines = read_lines dataFileName in
	
	let rows = E.map begin fun line ->
		match Pcre.split ~pat:" +" line with
		| h::t -> 
			let v   = L.map float_of_string t in
			make_row h v
		| _ -> failwith 
			(sprintf "ERROR: malformed line in %s: %s" dataFileName line)
	end lines |> L.of_enum in
	
	let dreps = if addDreps then	
		 L.make Const.bucketsN addVals 
	else
		let r = L.find (fun r -> r.nameROW = drepsName) rows in
		r.vectorROW in
		
	let rows = L.map begin fun ({vectorROW=v} as r) ->
			let bds = L.map2 (-.) v dreps |> L.map fabs in
			let d   = Mathy.euclidian_distance_list v dreps in
			{ r with buckDistsROW=bds;distanceROW=d }
	end rows in


	L.print ~first:"" ~sep:tab ~last:"" String.print oc 
	["global";"fof";"utility";"maturity";"jumpUtil";"jumpFOF";"week"];
	L.print ~first:tab ~sep:tab ~last:tab (fun oc x -> fprintf oc "b%d" x) oc fullBucketRange;
	if buckDists then
		L.print ~first:"" ~sep:tab ~last:tab (fun oc x -> fprintf oc "d%d" x) oc fullBucketRange
	else ();
	String.print oc "distance";
	newline oc;

	leprintfln "has %d rows!" (L.length rows);
	
	(* E.take 5 *)
	rows |> L.iter (print_row ~buckDists oc);
	
	if tostdout then () else close_out oc
	