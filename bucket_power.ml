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


let b2b: dreps -> day_buckets -> day_b2b =
  fun dreps bucks ->
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
   
  
let b2b_ratios: bool -> day_b2b -> rates4 =
  fun toFullDay b2bs ->
  let r4 = b2bs |> A.to_list |> L.map begin fun b2b ->
    let dayNorm = L.fold_left (fun res tobs -> res + L.sum tobs) 0 b2b
      |> float in       
    L.mapi begin fun i tobs ->
      let bucketNorm = L.sum tobs |> float in
      let before,selfRest = L.split_at i tobs in
      let self,after  = L.split_at 1 selfRest in
      let total3,rogueTotal = 
        if toFullDay then dayNorm,bucketNorm 
                     else bucketNorm,dayNorm in 
      list_norm total3 before, list_norm total3 self, 
      list_norm total3 after,  list_norm rogueTotal self
    end b2b
  end in
  carveTL fst4 r4, carveTL snd4 r4, carveTL trd4 r4, carveTL frh4 r4
  
  
let bucket_lens: day_buckets -> int_rates =
  fun bucks ->
    A.to_list bucks |> L.map begin fun bucket ->
      L.map S.cardinal bucket
    end


let newBucketMoves: day -> bucket_moves =
  fun day -> { sinceBM=day; trackBM=[] }


let moving: day_buckets -> moving =
  fun bucks ->
  let h = H.create Const.usersN in
  A.iteri begin fun day buckets ->
    L.iteri begin fun bucket_pos bucket ->
      S.iter begin fun user ->
        let { trackBM =track} as m = 
        match H.find_option h user with
          | Some m -> m
          | _ -> 
            begin
               let m = newBucketMoves day in
               H.add h user m;
               m
            end in
        let track =
          if L.is_empty track then [(bucket_pos,1)]
          else
            match L.hd track with
            | b,n when b = bucket_pos -> (b,succ n)::(L.tl track)
            | _ ->                   (bucket_pos,1)::track in
        H.replace h user {m with trackBM=track}
      end bucket
    end buckets
  end bucks;
  h
  
  
let movingRanks: moving -> moving_ranks =
  let h = H.create Const.movingRanksN in
  fun umoves ->
  H.iter begin fun user { trackBM=track } ->
    let firstBucket = match (L.backwards track |> E.peek) with
    | Some (b,_) -> b
    | _ -> failwith "cannot have empty track in movingRanks" in
    let lastBucket = match track with
    | (b,_)::_ -> b
    | _ -> failwith "cannot have empty track in movingRanks" in
    let rank = lastBucket - firstBucket in
    let rankSet = H.find_default h rank S.empty in
    let rankSet = S.add user rankSet in
    H.replace h rank rankSet
  end umoves;
  let a = H.enum h |> A.of_enum in
  A.sort compPairAsc1 a;
  a