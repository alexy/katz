open T
open H

type attachment_strategy =
    GlobalUniformAttachment 
  | GlobalMentionsAttachment
  | FOFUniformAttachment
  | FOFMentionsAttachment
  | FOFSocCapAttachment

(* this order corresponds to the order in which the data must be computed *)
type strategy_features = string list

type gen_opts = { jumpProbUtilGO : float; jumpProbFOFGO : float;
                  globalStrategyGO : attachment_strategy; 
                  fofStrategyGO : attachment_strategy;
                  minCapDaysGO : int; minCapGO : float;
                  strategyFeaturesGO : strategy_features }

type degr = { inDegreeDG : user_int_hash option; outDegreeDG : user_int_hash option; 
              inDePropsDG : int_proportions option;
              fnumsDG : fnums option; fnofsDG : fnofs option;
              fnumMentsDG: fnofs option; fnofMentsDG : fnofs option;
              fsocsDG : fsocs option;   fscofsDG: fsocs option }
              
              
let degrInDegree {inDegreeDG =x}   = match x with Some x -> x | _ -> failwith "must have inDegreeDG"
let degrOutDegree {outDegreeDG =x} = match x with Some x -> x | _ -> failwith "must have outDegreeDG"
let degrInDeProps {inDePropsDG =x} = match x with Some x -> x | _ -> failwith "must have inDePropsDG" 
let degrFnums {fnumsDG =x}         = match x with Some x -> x | _ -> failwith "must have fnumsDG" 
let degrFnofs {fnofsDG =x}         = match x with Some x -> x | _ -> failwith "must have fnofsDG" 
let degrFnumMents {fnumMentsDG =x} = match x with Some x -> x | _ -> failwith "must have fnumMentsDG" 
let degrFnofMents {fnofMentsDG =x} = match x with Some x -> x | _ -> failwith "must have fnofMentsDG" 
let degrFsocs {fsocsDG =x}         = match x with Some x -> x | _ -> failwith "must have fsocsDG" 
let degrFscofs {fscofsDG =x}       = match x with Some x -> x | _ -> failwith "must have fscofsDG" 
      
let (inDegreeSF,outDegreeSF,inDePropsSF,fnumsSF,fnofsSF,fnumMentsSF,fnofMentsSF,fsocsSF,fscofsSF) =
  ("inDegreeSF","outDegreeSF","inDePropsSF","fnumsSF","fnofsSF","fnumMentsSF","fnofMentsSF","fsocsSF","fscofsSF")
let strategyFeaturesInOrder : strategy_features = 
  [inDegreeSF;outDegreeSF;inDePropsSF;fnumsSF;fnofsSF;fnumMentsSF;fnofMentsSF;fsocsSF;fscofsSF]
  
(* the order in each sublist does not have to stisfy the definition above *)
type strategies_features = (attachment_strategy * strategy_features) list

let strategyFeatures : strategies_features =
[
GlobalUniformAttachment,  [inDegreeSF;inDePropsSF];
GlobalMentionsAttachment, [inDegreeSF;inDePropsSF];
FOFUniformAttachment,     [fnumsSF;fnofsSF];
FOFMentionsAttachment,    [fnumsSF;fnumMentsSF;fnofMentsSF];  (* fnums used to skip in growUtility *)
FOFSocCapAttachment,      [fnumsSF;fsocsSF;fscofsSF]
]
                 
              
type edge_counts      = (string,int) H.t
type edge_count_list  = (string * int) list
type edge_count_lists = edge_count_list list

let showStrategy strat =
match strat with
  | GlobalUniformAttachment  -> "Global Uniform"
  | GlobalMentionsAttachment -> "Global by Mentions"
  | FOFUniformAttachment     -> "FOF Uniform"
  | FOFMentionsAttachment    -> "FOF by Mentions"
  | FOFSocCapAttachment      -> "FOF by SocCaps"
