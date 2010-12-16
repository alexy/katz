open Common

let simulate dstarts denums =
  assert (A.length dstarts = A.length denums);
  let usersN = 5000000 in
  let ereps: graph = H.create usersN in (* dreps to be *)
  let users: reps = H.create usersN in (* sets of users already existing, with total edges so far *)
  A.iteri begin fun day (newUsers: user list) ->
    (* we iterate over newUsers twice:
       add new users to the existing ones *)
    L.iter (fun user -> H.add users user 0) newUsers;
    let usersNums = H.enum users in
    let (anames,avals) = Proportional.rangeLists usersNums in
    (* we increment the last, maximum value of the range array 
       since Random.int can never reach the bound 
       Another way to get the bound:
       
       let bound = A.backwards avals |> E.peek |> Option.get |> succ in
       *)
    let bound = avals.((A.length avals)-1)+1 in
    
    (* grow new edges *)
    L.iter begin fun (fromUser: user) ->
      let numEdges = H.find_default (fst denums.(day)) fromUser (0,0) |> fst in
      let fromDay = Dreps.userDay ereps fromUser day in
      E.iter begin fun _ ->
        let n' = Proportional.pick avals bound in
        match n' with 
        | None -> ()
        | Some n -> 
          let toUser = anames.(n) in
          hashInc fromDay toUser 
      end (E.range 1 ~until:numEdges)
    end newUsers
  end dstarts;
  ereps