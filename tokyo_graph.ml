open Tokyo_cabinet
open Batteries_uni
open Utils

(* This proved innecessary since HDB.cstr_t = string in fact already:
   let string_of_cstr = Tokyo_common.Cstr_string.of_cstr *)

let fetchGraph fileName maxElems progress = 
  let tc = HDB.new_ () in
  HDB.open_ tc ~omode:[Owriter] fileName;
  HDB.iterinit tc;
  (*  int -> HDB.t -> int option -> graph *)
  let rec collect maxElems tc count acc = 
      let (haveMax,theMax) = match maxElems with
        | Some n -> (true,n)
        | _ -> (false,0) 
        in 
      let k = tc |> HDB.iternext in
      if not (String.is_empty k) && (haveMax || count < theMax) then begin  
      (* let _ = match ... in -- vs -- ignore begin match ... end -- what's cuter? *)
            ignore begin match progress with
                    | Some n when count mod n == 0 -> leprintf "."
                    | _ -> () end;
            let v = HDB.get tc k in (* raises exception when missing! here should be always present from iternext key *)
            collect maxElems tc (succ count) ((k,v)::acc)
          end
        else acc |> List.rev |> Json_graph.json2graph
  in collect maxElems tc 0 []
