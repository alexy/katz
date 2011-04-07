open Common
open Getopt

let simsN     = 250
let bucketsN  = 7
let week'      = ref None
let byDist'    = ref false      
let tostdout'  = ref false
let outdir'    = ref (Some "weeks")
let addDreps'  = ref false
let addVals'   = ref 1.0
let showJumps' = ref false
let infix'     = ref None
let tex'       = ref false
let head'      = ref None
let table'     = ref false
let doc'       = ref false
let debug'     = ref false

let showNB'    = ref true
let showMC'    = ref true
let afterN'    = ref 10

let specs =
[
	('c',"stdout",      (set tostdout' (not !tostdout')), None);
  ('o',"outdir",  None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir",   (set outdir' None),     None);
  ('r',"dreps",       (set addDreps' true),   None);
  (noshort,"nodreps", (set addDreps' false),  None);
  ('x',"val",         None, Some (fun x -> addVals' := float_of_string x));
  ('j',"jumps",       (set showJumps' true),  None);
  (noshort,"nojumps", (set showJumps' false), None);
  ('i',"infix", None, Some (fun x -> infix' := Some x));
  ('i',"noinfix",     (set infix' None),      None);
  ('t',"tex",         (set tex' true),        None);
  (noshort,"tex",     (set tex' false),       None);
  ('h',"head", None, Some (fun x -> head' := Some (int_of_string x)));
  (noshort,"nohead",  (set head' None),       None);
  ('e',"table",       (set table' true),      None);
  (noshort,"notable", (set table' false),     None);
  ('a',"doc",         (set doc' true),        None);
  (noshort,"nodoc",   (set doc' false),       None);
  ('d',"distance",    (set byDist' true),     None);
  (noshort,"nodistance", (set byDist' false), None);
  ('D',"debug",       (set debug' true),      None);
  (noshort,"nodebug", (set debug' false),     None);
  ('w',"week", None, Some (fun x -> week' :=  Some (int_of_string x)));
  (noshort,"noweek",  (set week' None),       None);
  ('N',"nb",          (set showNB' true),     None);
  (noshort,"nonb",    (set showNB' false),    None);
  ('M',"mc",          (set showMC' true),     None);
  (noshort,"mc",      (set showMC' false),    None);
  ('A',"after", None, Some (fun x -> afterN' := int_of_string x))
]


let findAppendIf cond len pred a l =
  if cond then
    let i = A.findi pred a in
    if i < len then l
    else i::l
  else l
  

let makeRowNumber ?(afterN=10) ?(showNs=true) ?(sep="") n =
  match showNs with 
    | true when n >= afterN -> sprintf "%d %s" (succ n) sep
    | true -> sep
    | _ -> ""
   

let makeWeek ?(dash="") week =
  match week with
    | Some wk -> sprintf "%s%dwk" dash wk
    | _ -> ""
    

let makeSuffix infix week byDist showJumps head table doc tex =
  let letter x cond = 
    match cond with
      | true -> x
      | false -> "" in
  let ext = 
    match tex with
      | true  -> "tex"
      | false -> "txt" in
  let infix = 
    match infix with
      | Some i -> i
      | None when byDist -> "d"
      | _ -> "a" in
  let j = letter "j" showJumps in
  let h = 
    match head with
      | Some n -> string_of_int n
      | _ -> "" in
  let w  = makeWeek week in
  let t  = letter "t" table in
  let d  = letter "d" doc in
  let td = 
    match t,d with
    | "t","d" -> "d"
    | _ -> t^d in
  sprintf ".%s%s%s%s%s.%s" infix j h td w ext


let docHead oc =
  String.print oc "
\\documentclass{article}
\\usepackage{booktabs}
\\begin{document}
\\pagenumbering{gobble} 
"

let docTail oc =
  String.print oc "
\\end{document}
"
  
let tableHead oc ns jumps =
  let nada =  "","" in
  let n_colspec,n_heading =
    if ns then "r","\\emph{\\#} & " else nada in
  let j_colspec,j_heading = 
    if jumps then "l"," & \\emph{jumps}" else nada in
  fprintf oc "
\\begin{table}
\\centering
\\begin{tabular}{|%slrr%s|}
\\toprule
%s\\emph{simulation} & \\emph{rank} & \\emph{rise} %s \\\\
\\midrule
" n_colspec j_colspec n_heading j_heading

let tableTail oc caption label =
    fprintf oc "
\\bottomrule
\\end{tabular}
\\caption{\\small %s}
\\label{table:%s}
\\end{table}
" caption label

  
let () =
	let args = getOptArgs specs in
	
	let tostdout,   outdir,   addDreps,   addVals,   showJumps =
			!tostdout', !outdir', !addDreps', !addVals', !showJumps' in
			
  let infix,   head,   doc,   byDist,   debug =
      !infix', !head', !doc', !byDist', !debug' in
      
  let week,   afterN,   showNB,   showMC =
      !week', !afterN', !showNB', !showMC' in
      
  let table = if doc then true else !table' in
  let tex = if doc || table then true else !tex' in
  
	let outdir = if tostdout then None else outdir in

	let dataFileName =
	match args with
	| name::restArgs -> name
	| _ -> failwith "usage: dataframe filename"
	in

	mayMkDir outdir;

  let baseName  = dropText ".txt" dataFileName in

  (* for self, we search on the basis of the first week of the pair,
     but name on the last week for consistency with the rest! *)
  let tableName = sprintf "%s%s" baseName (makeWeek ~dash:"-" week) in
  let week = if addDreps then Option.map pred week else week in
  
	let oc = if tostdout then stdout
	else begin
	  let suffix = makeSuffix infix week byDist showJumps head table doc tex in
		let saveName = tableName ^ suffix |> mayPrependDir outdir in
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
  
  let drepsV = weeks --> "dreps" |> L.hd |> snd in
  
  if debug then begin
    printf "dreps's weeks length = %d\n" (L.length (weeks --> "dreps"));
    L.print ~first:"dreps: [" ~last:"]\n" Float.print stderr drepsV
  end;
  
  let distances =
  L.map begin fun wk ->
    H.map (fun base ws -> L.Exceptionless.assoc wk ws) weeks |> 
    H.enum |> L.of_enum |>
    L.filter_map begin function 
      | (base,Some v) -> 
        let d = Mathy.euclidian_distance_list v drepsV in
        if d = nan then None
                   else Some (base,d)
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
  
  if debug then
    let key = "rreps" in
    let first = sprintf "%s ranksH: [" key in
    L.print ~first ~last:"]\n" (Pair.print Int.print Int.print) stderr (ranksH --> key)
  else ();
  
  let rankd = list_of_hash ranksH |>
  L.filter_map begin fun (base,wrs) ->
    try
      let rs = L.map snd wrs in
      let last = L.last rs in
      let d = 
        match week with
          | Some wk -> L.assoc wk wrs
          | _ -> L.hd rs in
      let delta = d - last in
      let diffs = list_diffs rs in
      Some (base,d,delta,diffs)
    with _ -> None
  end |> Array.of_list in
  
  
  let sort32 (_,d1,delta1,_) (_,d2,delta2,_) =
    match compare delta1 delta2 with
    | 0 -> compare d1 d2
    | x -> x in

  let sort23 (_,d1,delta1,_) (_,d2,delta2,_) =
    match compare d1 d2 with
    | 0 -> compare delta1 delta2
    | x -> x in
  
  
  A.sort (if byDist then sort23 else sort32) rankd;
  
  if debug then begin
    let base_rankd_0,_,_,_ = rankd.(0) in
    let base_d0, d0 =  (L.last distances).(0) in
    leprintfln "rankd 0: base %s, distances 0 for week %d: base %s, distance %f" 
      base_rankd_0 maxWeek base_d0 d0
  end;
  
  let sep,eol =
  match tex with
  | true ->  "& ", " \\\\"
  | false -> "",   "" in

  let a = mayApply (fun n a -> A.sub a 0 n) head rankd in
  let l = A.to_list a |> L.mapi (fun i x -> i,x) in
  let len = L.length l in
  
  let z = [] in
  let rankd1 = A.map (fun (x,_,_,_) -> x) rankd in
  let z = findAppendIf showNB len ((FILTER (_* "cb" | "dreps")) |- not) rankd1 z in
  let z = findAppendIf showMC len (FILTER _* "cb6f")        rankd1 z in
  let z = L.sort z |> L.map (fun i -> i, rankd.(i)) in
  let l = l @ z in
  let showNs = L.length l > len in
  let l = L.map (fun (i,x) -> makeRowNumber ~showNs ~afterN ~sep i,x) l in
  
  let print_jumpless oc (i,(x,y,z,_)) = fprintf oc "%s%s %s%d %s%d%s" 
    i x sep y sep z eol in
  (* thelema: If you want to print a bunch of things to a single string, 
     use IO.output_string () to create your output; 
     to_string used for a single call here: *)
  let print_jumps oc (i,(x,y,z,w)) = fprintf oc "%s%s %s%d %s%d %s%s%s" 
    i x sep y sep z sep (((L.print Int.print) |> IO.to_string) w) eol in
  
  let row_print = if showJumps then print_jumps else print_jumpless in
  
  if doc   then docHead   oc                  else ();
  if table then tableHead oc showNs showJumps else ();
  L.print ~first:"" ~sep:"\n" ~last:"\n" row_print oc l;
  if table then tableTail oc tableName tableName else ();
  if doc   then docTail oc                       else ()