open Common

let staying: day_buckets -> staying = 
  fun bucks ->
  let maxBuckets = A.map L.length bucks |> A.max in
  let a = A.init maxBuckets (power10 |- H.create) in
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
      let toBuckets = A.init numBuckets (fun _ -> ref 0) in

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
  
  
let stay_over: staying -> int -> staying * staying_totals =
  fun stay n ->
  A.map begin fun bucket ->
    A.filter begin fun (_,count) -> 
      count >= n
    end bucket |> 
    fun x -> x,A.length x
  end stay |> array_split 
   
