open Common
open Getopt

let minDays' = ref 7
let minCap'  = ref 1e-35 
let mark'    = ref ""
let specs =
[
  ('d',"mindays",None,Some (fun x -> minDays' := int_of_string x));
  ('c',"mincap", None,Some (fun x -> minCap'  := float_of_string x));
  ('k',"mark",   None,Some (fun x -> mark'    := x))
]


let () =
  let args = getOptArgs specs in
  
  let minDays,   minCap,   mark =
      !minDays', !minCap', !mark' in
      
  let dcapsName =
  match args with
    | dcapsName::restArgs -> dcapsName
    | _ -> failwith "usage: save_caps [-d mindays] [-c mincap] dcapsName"    
  in        
  (* j is for just caps *)
  let baseName = cutPath dcapsName in
  let capsName = sprintf "j%s%s" mark baseName in
  let sort = true in
  
  leprintfln "reading dcaps from %s, saving caps in %s" 
    dcapsName capsName;
    
  let dcaps: user_day_reals = loadData dcapsName in
  let caps:  day_caps = Dcaps.mature_day_caps minDays minCap ~sort dcaps in
  
  saveData caps capsName
