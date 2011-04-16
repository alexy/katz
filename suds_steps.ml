open Common
open Ustats
open Sgraph
open Suds_local

(* updates stats in the original ustats! *)
let socUserDaySum (* : sgraph -> day -> user -> ustats -> terms_stat = fun *) sgraph day user stats (* -> *) =
  let {drepsSG=dreps;dmentsSG=dments;ustatsSG=ustats} = sgraph in
  let dr_ = getUserDay user day dreps in
  let dm_ = getUserDay user day dments in
  (* TODO with open Option just locally -- possible? *)
  if not (Option.is_some dr_ || Option.is_some dm_) then
    None
  else (* begin..end extraneous around the let chain? *)
    (* NB: don't match dayUS=day, it will shadow the day parameter! *)
    let {socUS =soc; insUS =ins; outsUS =outs; totUS =tot; balUS =bal} = stats in
    
    let outSum =
      match dr_ with
        | None -> 0.
        (* TODO can we pre-fix currying to speed up stepOut? *)
        | Some dr -> H.fold (stepOut ustats user) dr 0. in

    let (inSumBack,inSumAll) =
          match dm_ with
            | None -> (0.,0.)
            | Some dm -> H.fold (stepIn ustats user) dm (0.,0.) in

    let terms = (outSum, 
                 inSumBack, 
                 inSumAll) in

     (* flux suggested this HOF to simplify match delineation: *)
    let call_some f v = match v with None -> () | Some v -> f v in
    call_some (addMaps ins)  dr_;
    call_some (addMaps outs) dm_;
    begin match (dr_, dm_) with
      | (Some dr, None) ->     addMaps tot dr; addMaps      bal dr 
      | (None, Some dm) ->     addMaps tot dm; subtractMaps bal dm 
      | (Some dr, Some dm) ->  addMaps tot dr; addMaps      tot dm;
                               addMaps bal dr; subtractMaps bal dm
      | (None,None) -> () end; (* should never be reached in this top-level if's branch *)
    Some terms
