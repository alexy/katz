open Common

let staying bucks =
  let a = A.init 7 (fun i -> let n = power10 i in H.create n) in
  A.iteri begin fun day buckets ->
    L.iteri begin fun i bucket ->
      S.iter begin fun user ->
        hashInc a.(i) user (* can store days themselves *)
      end bucket
    end buckets
  end bucks;
  A.map begin fun h ->
    schwartzSortIntHashDesc h
  end a
      
      
(* let stay_over  *)


let findUserBucket user buckets =
  let bucketSeq = L.backwards buckets in
  let totalBuckets = L.length buckets in
  let rec aux i =
    match E.get bucketSeq with
    | Some bucket when S.mem user bucket -> Some i
    | Some _ -> aux (pred i)
    | None -> None in
  aux (pred totalBuckets)


let b2b dreps bucks =
  A.mapi begin fun day buckets ->
    let numBuckets = L.length buckets in
    L.map begin fun bucket ->
      let toBuckets = A.create numBuckets (ref 0) in

      S.iter begin fun user -> 
        match Dreps.getUserDay user day dreps with
        | None -> ()
        | Some reps -> 
          H.iter begin fun toUser num ->
            match findUserBucket toUser buckets with
            | Some i -> incr toBuckets.(i)
            | None -> leprintf "ERROR: user %s is not found in any bucket on day %d!" user day
          end reps
      end bucket;

      A.to_list toBuckets |> 
      L.map (!)
    end buckets;
  end bucks