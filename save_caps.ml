open Common
open Getopt

let minDays' = ref 7
let minCap'  = ref 1e-35 
let mark'    = ref ""
let prefix'  = ref "j"
let outdir'  = ref (Some "jcaps")
let specs =
[
  (noshort,"prefix",None,Some (fun x -> prefix' := x));
  (noshort,"outdir",None,Some (fun x -> outdir' := Some x));
  (noshort,"nodir", (set outdir' None), None);
  ('d',"mindays",None,Some (fun x -> minDays' := int_of_string x));
  ('c',"mincap", None,Some (fun x -> minCap'  := float_of_string x));
  ('k',"mark",   None,Some (fun x -> mark'    := x))
]


let () =
  let args = getOptArgs specs in
  
  let minDays,   minCap,   mark =
      !minDays', !minCap', !mark' in
      
  let prefix, outdir =
      !prefix', !outdir' in
  
  let dcapsName,outdir =
  match args with
    | dcapsName::outdir::restArgs -> dcapsName,Some outdir
    | dcapsName::restArgs         -> dcapsName,outdir
    | _ -> failwith "usage: save_caps [-d mindays] [-c mincap] dcapsName [outdir]"    
  in        
  (* j is for just caps *)
  let baseName = cutPathZ dcapsName in
  let capsName = sprintf "%s%s%s" prefix mark baseName |> mayPrependDir outdir in
  let sort = true in
  
  leprintfln "reading dcaps from %s, saving caps in %s" 
    dcapsName capsName;
    
  let dcaps: user_day_reals = loadData dcapsName in
  let caps:  day_caps = Dcaps.mature_day_caps minDays minCap ~sort dcaps in
  
  mayMkDir outdir;
  saveData caps capsName
