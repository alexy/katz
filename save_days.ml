open Common
open Getopt
open By_day
  
let saveEdges'    = ref false
let saveNums'     = ref true
let prefixByday'  = ref "byday"
let prefixDenums' = ref "denums"
let outdirByday'  = ref (Some !prefixByday')
let outdirDenums' = ref (Some !prefixDenums')

let specs =
[
  (noshort,"prefixByday", None,Some (fun x -> prefixByday'  := x));
  (noshort,"prefixDenums",None,Some (fun x -> prefixDenums' := x));
  (noshort,"outdirByday", None,Some (fun x -> outdirByday'  := Some x));
  (noshort,"outdirDenums",None,Some (fun x -> outdirDenums' := Some x));
  (noshort,"nodirByday", (set outdirByday'  None), None);
  (noshort,"nodirDenums",(set outdirDenums' None), None);
  ('e',"edges",(set saveEdges' (not !saveEdges')), None);
  ('n',"nums", (set saveNums'  (not !saveNums')),  None);
  (noshort,"noedges",(set saveEdges' false),       None);
  (noshort,"nonums", (set saveNums'  false),       None)
]

let () = 
  let args = getOptArgs specs in
  
  let saveEdges,   saveNums =
      !saveEdges', !saveNums' in
      
  let prefixByday, prefixDenums, outdirByday, outdirDenums =
      !prefixByday', !prefixDenums', !outdirByday', !outdirDenums' in

  let drepsName = 
  match args with
  | drepsName::restArgs -> drepsName
  | _ -> failwith "usage: save_days drepsName"
  in
   
  let baseName = cutPath drepsName in
  let edgeName = sprintf "%s-%s" prefixByday  baseName |> mayPrependDir outdirByday in
  let numsName = sprintf "%s-%s" prefixDenums baseName |> mayPrependDir outdirDenums in
  leprintfln "reading graph from %s, saving byday edges in %s and edge nums in %s" drepsName edgeName numsName;

  let dreps = loadData drepsName in
  leprintfln "loaded %s, %d" drepsName (H.length dreps);
  
  let byday: days = by_day dreps in
  leprintfln "byday has length %d" (Array.length byday);

  if saveEdges then saveData byday edgeName else ();
  
  if saveNums then
    let nums : day_edgenums = dayEdgenums byday in
    saveData nums numsName
  else ()
