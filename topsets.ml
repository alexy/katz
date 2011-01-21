open Common

type rates = (float list) list
module S=Set.StringSet
let floatSize = S.cardinal |- float
type buckets = S.t list
type day_buckets = buckets array
          
let buckets: Cranks.rank_users -> buckets =
  fun ranks ->
  let aux (res, bucket, used, bucketSize) users =
    let usersLength = L.length users in
    let newUsed = used + usersLength in
    if newUsed <= bucketSize 
      then begin
        L.iteri (fun i x -> bucket.(used+i) <- x) users;
        (res, bucket, newUsed, bucketSize)
      end
      else
      let power10 n start res =
        let rec exceed n acc res =
          if acc > n then (acc,res)
          else exceed n (acc*10) ([||]::res) in
          exceed n start res in
      let (newBucketSize,res) = power10 usersLength (bucketSize*10) (bucket::res) in
      let newBucket = A.append (A.of_list users) 
        (A.create (newBucketSize - usersLength) "") in
      (res, newBucket, usersLength, newBucketSize)  
  in 
  let (res, lastBucket, _, _) = L.fold_left aux ([], A.create 10 "", 0, 10) ranks in   
  let res = if (A.length lastBucket) > 0 then lastBucket::res else res in
  (* TODO: either carry used size for each bucket and A.sub before
     converting to the set, or simply subtract "" form the set! *)
  let res = L.rev res |> L.map (A.enum |- S.of_enum |- S.remove "") in
  
  leprintf "buckets size: %d " (L.length res);
  List.print Int.print stderr (L.map S.cardinal res |> L.take 20);
  leprintfln "";
  res


let bucketChangeRates bs1 bs2 =
  let rec aux bs1 bs2 acc = 
    match (bs1,bs2) with
    | (b1::bs1,b2::bs2) -> 
      let inter = S.inter b1 b2 in
      let stayRate = (floatSize inter) /. (floatSize b1) in
      aux bs1 bs2 (stayRate::acc)
    | _ -> L.rev acc
  in
  aux bs1 bs2 []
  
let bucketDynamics: day_buckets -> rates = 
  fun bucks ->
  let bucksEnd  = pred (A.length bucks) in
  let bucksRest = A.sub bucks 1 bucksEnd in
  A.fold_left begin fun (res,prevBucks) bucks ->
    let rates = bucketChangeRates prevBucks bucks in
    leprintf ".";
    (rates::res, bucks)
  end ([],bucks.(0)) bucksRest |> fst |> L.rev
  
let bucketOverlaps: day_buckets -> day_buckets -> rates =
  fun b1 b2 ->
  A.map2 begin fun db1 db2 ->
      bucketChangeRates db1 db2
  end b1 b2 |> list_of_array