open Common
open Sgraph

let usersN = Const.usersN
let daysN  = Const.daysN

let simulate ?(dreps_day=(H.create usersN,0)) ?duvals ?uniform dstarts denums =
  assert (A.length dstarts = A.length denums);
  let realVals = Option.is_some duvals in
  (* sets of users already existing, with total edges so far *)
  let ((ereps,firstDay), (users: reps)) = 
    match dreps_day with
    | (dreps,_) when (H.is_empty dreps) -> 
        let users = H.create usersN in
        (dreps_day, users)
    | (dreps,theDay) (* when theDay > 0 *) -> begin
        let before = Dreps.before dreps theDay |> 
        (* leaving empty repliers is OK, they'll be filled,
        but obscures growth obervations *)
        H.filter (fun days ->  not (H.is_empty days)) in
        (* by outgoing, not by mentions:
          let users = Dreps.userTotals dreps in *)
        (* instead of computing a reduced dments here
           from the reduced dreps each time, we can
           precompute cumulative mentions upto each day
           and read it here; 
           similarly, we can load any daily values,
           such as karmic social capital, for 
           general preferential attachment *)
        leprintf "inverting time-limited dreps... ";
        let bments = Invert.invert2 before in
        leprintfln "done";
        let users = Dreps.userTotals bments in
        ((before,theDay),users) 
      end in
  let edgeCount = ref 0 in
  let lastDay = (A.length dstarts) - 1 in

  (* A.iteri begin fun day (newUsers: user list) -> *)
  E.iter begin fun day ->
    let newUsers = dstarts.(day) in
    L.iter (fun user -> H.add users user 0) newUsers;
    let numUsers = H.length users in
    leprintfln "\nday %d, total repliers: %d, mentioners: %d" 
      day (H.length ereps) numUsers;
    (* TODO this is really a lazy way to have a union of in/float array
       we can wrap the whole simulate into a functor with int/float as 
       a parameter type to0 do it for reals... or integers, properly;
       or we can modularize Proportional better, making them store names
       and return those names directly *)
    let (anames,ivals,avals) = match duvals with
                                       (* TODO parameterize 1e-35 *)
    | Some dv -> let (ns,vs) = Proportional.rangeLists (+.) 1e-35 0. (H.enum dv.(day)) in
                 let dummyIntArray = A.create 0 0 in
                 (ns,dummyIntArray,vs)
    | None ->    let (ns,vs) = Proportional.intRangeLists (H.enum users) in
                 let dummyFloatArray = A.create 0 0. in
                 (ns,vs,dummyFloatArray)
    in 

    (* grow new edges *)
    E.iter begin fun (fromUser,numEdges) ->
      (* should we smooth here as well? *)
      if numEdges > 0 then begin
        let fromDay = Dreps.userDay ereps fromUser day in
        E.iter begin fun _ ->
          let toUser = 
            match uniform with
            (* since anames is padded with a dummy 0th element, 
               we pick 1-based when uniform-direct *)
            | Some _ -> randomElementBut0th anames
            | _ ->
            if realVals
              then Proportional.pickFloat2 (anames,avals)
              else Proportional.pickInt2   (anames,ivals)
          in 
          hashInc fromDay toUser;
          hashInc users toUser;
          incr edgeCount; if !edgeCount mod 10000 = 0 then leprintf "."
        end (E.range 1 ~until:numEdges)
      end (* numEdges > 0 *)
    end (By_day.numUserEdges denums.(day))
  end (E.range firstDay ~until:lastDay); (* dstarts *)
  ereps


(* called from soc_run_gen, a version of the above without integers
   given an sgraph with social capitals form previous cycle,
   grow the given number of edges in this cycle,
   attaching preferentially according to the current capital distribution *)
   
let growEdges userNEdges props smooth dreps dments day =
   let props = Proportional.rangeLists (+.) smooth 0. props in
   let edgeCount = ref 0 in
   H.iter begin fun fromUser numEdges ->
      if numEdges > 0 then begin
        let fromDay = Dreps.userDay dreps fromUser day in
        E.iter begin fun _ ->
          let toUser =  Proportional.pickFloat2 props in
          hashInc fromDay toUser;
          let toDay = Dreps.userDay dments toUser day in
          hashInc toDay fromUser;
          incr edgeCount; if !edgeCount mod 10000 = 0 then leprintf "."
        end (1 -- numEdges) (* E.range 1 ~until:numEdges *)
      end (* numEdges > 0 *)
    end userNEdges 
    
    
    