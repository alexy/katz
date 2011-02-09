open T
open H

type attachment_strategy =
    GlobalUniformAttachment 
  | GlobalMentionsAttachment
  | FOFUniformAttachment
  | FOFMentionsAttachment 

type gen_opts = { jumpProbUtilGO : float; jumpProbFOFGO : float;
                  globalStrategyGO : attachment_strategy; 
                  fofStrategyGO : attachment_strategy }

type degr = { inDegreeDG : user_int_hash; outDegreeDG : user_int_hash; 
              inDePropsDG : int_proportions;
              fnumsDG : fnums; fnofsDG : fnofs;
              fnumMentsDG: fnofs; fnofMentsDG : fnofs }
              
type edge_counts = (string,int) H.t
type edge_count_list = (string * int) list
type edge_count_lists = edge_count_list list

let showStrategy strat =
match strat with
  | GlobalUniformAttachment  -> "Global Uniform"
  | GlobalMentionsAttachment -> "Global by Mentions"
  | FOFUniformAttachment     -> "FOF Uniform"
  | FOFMentionsAttachment    -> "FOF by Mentions"
