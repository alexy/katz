open Common
include Soc_run_common
include Ustats_skew
include User_stats

type sgraph = 
  {drepsSG  : graph; dmentsSG : graph; 
   dcapsSG  : dcaps; dskewsSG : dskews;
   ustatsSG : user_stats}

let sgraphInit ?(dskews=emptyHash ())
	dreps dments dcaps ustats =
  {drepsSG=dreps; dmentsSG=dments; dcapsSG=dcaps; ustatsSG=ustats; dskewsSG=skews}
