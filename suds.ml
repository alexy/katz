open Common
open Soc_run_common
open Sgraph_local
open Sgraph_based

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
        | Some dr ->
        	(* leprintf "user: %s, dr size: %d" user (H.length dr); *)
            let step to' num res = 
              let toBal = H.find_default bal to' 0 in
              if toBal >= 0 then res
              else begin (* although else binds closer, good to demarcate *)
                let toSoc = getSocCap ustats to' in
                  if toSoc = 0. then res
                  else
                    let toOut = H.find_default outs to' 1 in
                    let toTot = H.find_default tot  to' 1 in
                    let term = float (num * toBal * toOut) *. toSoc /. float toTot in
                    res -. term (* the term is negative, so we sum positive *)
              end
            in
            H.fold step dr 0. in

    let (inSumBack,inSumAll) =
          match dm_ with
            | None -> (0.,0.)
            | Some dm ->
                let step to' num ((backSum,allSum) as res) =
                  let toSoc = getSocCap ustats to' in
                  if toSoc = 0. then res
                  else begin
                    let toIn  = H.find_default ins to' 1 in
                    let toTot = H.find_default tot to' 1 in
                    let allTerm  = float (num * toIn) *. toSoc /. float toTot in
                    let toBal = H.find_default bal to' 0 in
                    let backTerm = if toBal <= 0 then 0. else float toBal *. allTerm in
                    (backSum +. backTerm,allSum +. allTerm)
                  end
                in  
                H.fold step dm (0.,0.) in

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
