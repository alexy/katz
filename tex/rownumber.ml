open Batteries_uni
open Printf

let number = ref 0

let rec go ic =
  try
    let line = input_line ic in
    if String.starts_with line "\\hline" then 
      printf "%s\n" line
    else begin
      incr number;
      printf "%d & %s\n" !number line 
    end;
    go ic
  with End_of_file -> ()
  
let () =
  go stdin
