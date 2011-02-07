open Common
include Soc_run_common
include Ustats_skew
include User_stats

type degree = (user,int) H.t

type sgraph = 
  {drepsSG : graph; dmentsSG : graph; 
   dcapsSG : dcaps; dskewsSG : dskews;
   ustatsSG : user_stats;
   inDegreeSG : degree; outDegreeSG: degree;
   inDegreeProportionsSG : user array * int array}

let sgraphInit?(dskews=emptyHash ())
    ?(inDegree=emptyHash ()) ?(outDegree=emptyHash ())
    ?(inDegreeProportions=[||],[||]) 
     dreps dments dcaps ustats =
  {drepsSG=dreps; dmentsSG=dments; dcapsSG=dcaps; ustatsSG=ustats; dskewsSG=dskews;
  inDegreeSG=inDegree;outDegreeSG=outDegree;
  inDegreeProportionsSG=inDegreeProportions}
