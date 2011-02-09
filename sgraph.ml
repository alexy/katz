open Common
include Soc_run_common
include Ustats

type sgraph = 
  {drepsSG  : graph; dmentsSG : graph; 
   ustatsSG : user_stats}

let sgraphInit dreps dments ustats =
  {drepsSG=dreps; dmentsSG=dments; ustatsSG=ustats}
