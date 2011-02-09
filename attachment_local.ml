open T

type attachment_strategy =
    UniformAttachment 
  | MentionsAttachment 

type gen_opts = { jumpProbGO   : float;
                  attachmentStrategyGO : attachment_strategy }

type degr = { inDegreeDG : user_int_hash; outDegreeDG : user_int_hash; 
              inDePropsDG : int_proportions }
              
type edge_counts = int * int * int

let showStrategy strat =
match strat with
  | UniformAttachment  -> "Global Uniform"
  | MentionsAttachment -> "Global by Mentions"
