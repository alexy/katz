open Common

let simulate dstarts denums =
  assert (A.length dstarts = A.length denums);
  let usersN = 5000000
  let ereps = H.create usersN in (* dreps to be *)
  let users = H.create usersN (* sets of users already existing, with total edges so far *)
  A.iteri begin fun day newUsers ->
    (* we iterate over newUsers twice:
       add new users to the existing ones *)
    L.iter (fun user -> H.add users user 0) newUsers;
    let usersNums = H.enum users in
    let (anames,avals) = rangeLists usersNums in
    (* we increment the last, maximum value of the range array 
       since Random.int can never reach the bound 
       Another way to get the bound:
       
       let bound = A.backwards avals |> E.peek |> Option.get |> succ in
       *)
    let bound = avals.((A.length a)-1)+1 in
    
    (* grow new edges *)
    List.iter begin fun fromUser ->
      let numEdges = denums.(day) |> fst |> H.find_default fromUser (0,0) |> fst in
      let fromDay = Dreps.userDay ereps fromUser day in
      Enum.iter begin fun _ ->
        let n' = Proportional.pick avals bound in
        match n' with 
        | None -> ()
        | Some n -> 
          let toUser = anames.(n) in
          hashInc fromDay toUser 
      end (Enum.range 1 ~until:numEdges)
    end newUsers
  end dstarts
  ereps