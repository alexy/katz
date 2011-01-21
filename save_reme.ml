open Common
open By_day
  
let () = 
  let args = getArgs in
  let drepsName = 
  match args with
  | drepsName::restArgs -> drepsName
  | _ -> failwith "usage: save_reme drepsName"
  in
 
  let derepsName,demensName = "nr-"^drepsName,"nm-"^drepsName in
  leprintfln "reading graph from %s, saving dereps in %s and demens in %s" 
    drepsName derepsName demensName;
  let dreps: graph = loadData drepsName in
  leprintfln "loaded %s, %d" drepsName (H.length dreps);
  
  let (byday: days) = by_day dreps in
  leprintfln "byday has length %d" (Array.length byday);
  
  let dereps, demens = day_re_me byday in
  leprintfln "now saving dereps in %s, demens in %s" derepsName demensName;
  saveData dereps derepsName;
  saveData demens demensName;
