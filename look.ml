(* load the dcaps back and lookup a name *)

open Common
open Soc_run

(* module H=Hashtbl; let H_find = H.Exceptionless.find *)
module H = struct include BatHashtbl include BatHashtbl.Exceptionless end

let () = 
  let args = getArgs in
  match args with
    | dcfile::name::_ -> begin
        printf "%s" name;
        let dc : dcaps = loadData dcfile in
        match H.find dc name with 
          | None -> printf "? Not found\n"
          | Some v -> List.print (Pair.print Int.print Float.print) stdout v
      end
    | _ -> failwith "need a dcaps file name and a key to look up"