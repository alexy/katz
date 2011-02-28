open Printf
let () =
  let x = Sys.argv.(1) in
  printf "%s0 %s1wk\n%s1wk %s2wk\n%s2wk %s3wk\n%s3wk %s4wk\n" x x x x x x x x
  (* printf "%s0 %s2wk\n%s1wk %s3wk\n%s2wk %s4wk\n" x x x x x x *)
