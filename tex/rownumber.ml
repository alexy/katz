open Batteries_uni
open Getopt
open Printf

let getOptArgs specs =
  let restArgsE = Enum.empty () in
  let pushArg a = Enum.push restArgsE a in
  parse_cmdline specs pushArg;
  List.of_enum restArgsE |> List.rev

let parseIntList ?(sep=";") x = 
	String.nsplit x sep |> List.map int_of_string

let init' = ref 1
let inc'  = ref false
let h1'   = ref None
let h2'   = ref None
let specs =
[
  ('n',"start",None,Some (fun x -> init' := int_of_string x));
  ('i',"inc",(set inc' (not !inc')),None);
  ('h',"hlines", None,Some (fun x -> h1' := Some (int_of_string x)));
  ('H',"hlines2",None,Some (fun x -> h2' := Some (parseIntList x)));
  (noshort,"nohlines", (set h1' None),None);
  (noshort,"nohlines2",(set h2' None),None)
]


let countBound ns count =
	let rec aux ns ?step count =
		match ns,step with
		| (step::num::ns,_) when step * num < count -> aux ns ~step (count - step * num)
		| (step::_,_)
		| _,Some step 
			-> count mod step = 0
		| _ -> false
	in
	aux ns count
	
	
let may_hline (h1,h2) count =
	match h1,h2 with
	| (Some n,_)  when count mod n = 0
		-> printf "\\hline\n"
	| (_,Some ns) when countBound ns count
		-> printf "\\hline\n"
	| _ -> ()
	

let rec go number count hh saw_hl ic =
  try
    let line = input_line ic in
    if String.starts_with line "\\hline" then begin
      printf "%s\n" line;
      go number count hh saw_hl ic
    end
    else begin
      printf "%d & %s\n" number line;
			if not saw_hl then may_hline hh count else ();
      go (succ number) (succ count) hh saw_hl ic
    end
  with End_of_file -> ()

  
let () =
  let _ = getOptArgs specs in
  let inc,init,h1,h2 = !inc',!init',!h1',!h2' in
  let hh = h1,h2 in
  let n = if inc then succ init else init in
  go n 1 hh false stdin
