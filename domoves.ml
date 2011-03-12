open Common
open Getopt

let saveMoves'   = ref true
let prefixMoves' = ref "moves"
let outdirMoves' = ref (Some !prefixMoves')
let prefixRanks' = ref "mrank"
let outdirRanks' = ref (Some !prefixRanks')
let mark'        = ref ""
let specs =
[
  (noshort,"prefixMoves",None,Some (fun x -> prefixMoves' := x));
  (noshort,"outdirMoves",None,Some (fun x -> outdirMoves' := Some x));
  (noshort,"nodirMoves",                (set outdirMoves' None), None);
  (noshort,"prefixRanks",None,Some (fun x -> prefixRanks' := x));
  (noshort,"outdirRanks",None,Some (fun x -> outdirRanks' := Some x));
  (noshort,"nodirRanks",                (set outdirRanks' None), None);
  ('k',"mark",None,Some (fun x -> mark' := x))
]

let () =
  let args = getOptArgs specs in
  
  let saveMoves,   mark = 
      !saveMoves', !mark' in
  
  let prefixMoves,   outdirMoves =
      !prefixMoves', !outdirMoves' in
      
  let prefixRanks,   outdirRanks =
      !prefixRanks', !outdirRanks' in
      
  
  let bucksName,outdirRanks =
  match args with
    | bucksName::outdirRanks::restArgs -> bucksName,Some outdirRanks
    | bucksName::restArgs         -> bucksName,outdirRanks
    | _ -> failwith "usage: domoves bucksName [outdir]"      
  in  

  let baseName  = cutPathZ bucksName in
  let ranksName = sprintf "%s-%s%s" prefixRanks mark baseName |> mayPrependDir outdirRanks in
  let movesName = sprintf "%s-%s%s" prefixMoves mark baseName |> mayPrependDir outdirMoves in
  leprintf "reading bucks from %s, saving moving ranks in %s" bucksName ranksName;
  if saveMoves then
    leprintfln ", saving moves themselves in %s" movesName
  else
    le_newline;
    
  let bucks: day_buckets = loadData bucksName in

  let moves: moving       = Bucket_power.moving      bucks in
  let ranks: moving_ranks = Bucket_power.movingRanks moves in
  
  if saveMoves then begin
    mayMkDir outdirMoves;
    saveData moves movesName
  end
  else ();
  
  mayMkDir outdirRanks;
  saveData ranks ranksName
