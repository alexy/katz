(* Demonstration of the Getopt module *)

open Batteries_uni
open Getopt

let archive = ref false
and update  = ref false
and verbose = ref 0
and includ  = ref []
and output  = ref ""

let bip ()  = Printf.printf "\007"; flush stdout
let wait () = Unix.sleep 1 

let specs = 
[
  ( 'x', "execute", None, Some (fun x -> Printf.printf "execute %s\n" x));
  ( 'I', "include", None, (append includ));
  ( 'o', "output",  None, (atmost_once output (Error "only one output")));
  ( 'a', "archive", (set archive true), None);
  ( 'u', "update",  (set update  true), None);
  ( 'v', "verbose", (incr verbose), None);
  ( 'X', "",        Some bip, None);
  ( 'w', "wait",    Some wait, None)

]

let _ = 
  Array.print ~last:"]\n" String.print stdout Sys.argv;

  let restArgsE = Enum.empty () in
  let pushArg a = Enum.push restArgsE a in
  parse_cmdline specs pushArg;
  let restArgs = List.of_enum restArgsE |> List.rev in

  Printf.printf "archive = %b\n" !archive;
  Printf.printf "update  = %b\n" !update;
  Printf.printf "verbose = %i\n" !verbose;
  Printf.printf "output  = %s\n" !output;
  List.print ~first:"include: [" ~last:"]\n" String.print stdout !includ;

  List.print ~last:"]\n" String.print stdout restArgs
