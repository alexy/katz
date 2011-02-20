open Common
open Getopt
open By_day
  
let saveEdges' = ref false
let saveNums'  = ref true
let specs =
[
  ('e',"edges",(set saveEdges' (not !saveEdges')), None);
  ('n',"nums", (set saveNums'  (not !saveNums')),  None);
  (noshort,"noedges",(set saveEdges' false),       None);
  (noshort,"nonums", (set saveNums'  false),       None)
]

let () = 
  let args = getOptArgs specs in
  
  let saveEdges,   saveNums =
      !saveEdges', !saveNums' in

  let drepsName = 
  match args with
  | drepsName::restArgs -> drepsName
  | _ -> failwith "usage: save_days drepsName"
  in
   
  let edgeName = "byday-"^drepsName in
  let numsName = "denums-"^drepsName in
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
