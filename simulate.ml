open Common

let usersN = 5000000

let simulate ?(dreps_day=(H.create usersN,0)) dstarts denums ~duvals =
  assert (A.length dstarts = A.length denums);
  let realVals = Option.is_some duvals in
  (* sets of users already existing, with total edges so far *)
  let ((ereps,firstDay), (users: reps)) = 
    match dreps_day with
    | (dreps,_) when (H.is_empty dreps) -> 
        let users = H.create usersN in
        (dreps_day, users)
    | (dreps,theDay) (* when theDay > 0 *) -> begin
        let before = H.map begin fun user days -> 
          H.filteri (fun day _ -> day < theDay) days
        end dreps 
        (* leaving empty repliers is OK, they'll be filled,
        but obscures growth obervations *)
        |> H.filter (fun days ->  not (H.is_empty days)) in
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
    leprintfln "\nday %d, total repliers: %d, mentioners: %d" 
      day (H.length ereps) (H.length users);
    (* TODO this is really a lazy way to have a union of in/float array
       we can wrap the whole simulate into a functor with int/float as 
       a parameter type to0 do it for reals... or integers, properly;
       or we can modularize Proportional better, making them store names
       and return those names directly *)
    let (anames,ivals,ibound,avals,abound) = match duvals with
    | Some dv -> let (ns,vs) = Proportional.rangeLists (+.) 1e-35 0. (H.enum dv) in
                 let b = vs.((A.length vs)-1) in
                 let dummyIntArray = A.create 0 0 in
                 let dummyBound = 0 in
                 (ns,dummyIntArray,dummyBound,vs,b)
    | None ->    let (ns,vs) = Proportional.rangeLists (+)  1 0 (H.enum users) in
    (* we increment the last, maximum value of the range array 
       since Random.int can never reach the bound 
       Another way to get the bound:
       
       let bound = A.backwards avals |> E.peek |> Option.get |> succ in
       *)
                 let b = vs.((A.length vs)-1)+1 in
                 let dummyFloatArray = A.create 0 0. in
                 let dummyBound = 0. in
                 (ns,vs,b,dummyFloatArray,dummyBound)
    in    
    (* grow new edges *)
    E.iter begin fun (fromUser,numEdges) ->
      (* should we smooth here as well? *)
      if numEdges > 0 then begin
        let fromDay = Dreps.userDay ereps fromUser day in
        E.iter begin fun _ ->
          let n' = if realVals
            then Proportional.pickReal avals abound 
            else Proportional.pickInt  ivals ibound
          in
          match n' with 
          | None -> ()
          | Some n -> 
            let toUser = anames.(n) in begin
              hashInc fromDay toUser;
              hashInc users toUser;
              incr edgeCount; if !edgeCount mod 10000 = 0 then leprintf "."
            end (* new edge *)  
        end (E.range 1 ~until:numEdges)
      end (* numEdges > 0 *)
    end (By_day.numUserEdges denums.(day))
  end (E.range firstDay ~until:lastDay); (* dstarts *)
  ereps
