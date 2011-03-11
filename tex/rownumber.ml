open Batteries_uni
open Getopt
open Printf

let getOptArgs specs =
  let restArgsE = Enum.empty () in
  let pushArg a = Enum.push restArgsE a in
  parse_cmdline specs pushArg;
  List.of_enum restArgsE |> List.rev

let init'   = ref 0
let inc'    = ref false
let hlines' = ref None
let specs  =
[
  ('n',"start",None,Some (fun x -> init' := int_of_string x));
  ('i',"inc",(set inc' (not !inc')),None);
  ('h',"hlines",None,Some (fun x -> hlines' := Some (int_of_string x)));
  (noshort,"nohlines",(set hlines' None),None)
]


let rec go hlines sawHlines number ic =
  try
    let line = input_line ic in
    if String.starts_with line "\\hline" then begin
      printf "%s\n" line;
      go hlines true number ic
    end
    else begin
      printf "%d & %s\n" number line;
      begin match hlines with 
      | Some n when not sawHlines && number mod n = 0 -> printf "\\hline\n"
      | _ -> ()
      end;
      go hlines sawHlines (succ number) ic
    end
  with End_of_file -> ()

  
let () =
  let _ = getOptArgs specs in
  let inc,init,hlines = !inc',!init',!hlines' in
  
  let n = if inc then succ init else init in
  go hlines false n stdin
