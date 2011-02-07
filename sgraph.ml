open Common
open Ustats
open User_stats

type sgraph = 
  {drepsSG  : graph; dmentsSG : graph; 
   dcapsSG  : dcaps; ustatsSG : user_stats}

let sgraphInit dreps dments dcaps ustats =
  {drepsSG=dreps; dmentsSG=dments; dcapsSG=dcaps; ustatsSG=ustats}
