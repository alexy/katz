(* read rates and typeset a LaTeX table *)
open Common
open Getopt
open TeX

let latex'     = ref false
let tableDoc'  = ref false
let outDir'    = ref ""
let verbose'   = ref false

let specs =
[
  ('t',"tex",    (set latex'     true),None);
  ('d',"doc",    (set tableDoc'  true),None);
  ('o',"outdir", None, Some (fun x -> outDir' := x));
  ('v',"verbose",(set verbose'  true),None)
]

let () =
  let args = getOptArgs specs in
  
  let latex,   tableDoc,   outDir,   verbose = 
      !latex', !tableDoc', !outDir', !verbose' in
    
  let ratesName =
  match args with
  | x::[] -> x
  | _ -> failwith "texrates [-tT] ratesName"
  in
  
  let tex,suffix,asWhat = texParams latex tableDoc in

  let _,saveName = saveBase suffix ratesName in
  leprintfln "reading rates from %s, writing %s to %s %s"
    ratesName asWhat saveName (showDir outDir);
  
  let rates : rates = loadData ratesName in

  printShowTable tex ~verbose floatPrint rates outDir saveName