open Common

type rates = (float list) list
     
module S=Set.StringSet
let floatSize = S.cardinal |- float
     
let buckets ranks = 
  let aux (res,lastBucket,bucketSize) users =
    let newBucket = A.append lastBucket (A.of_list users) in
    if (A.length newBucket) < bucketSize 
      then
        (res, newBucket, bucketSize )
      else
        (newBucket::res, (A.create 0 ""),  (bucketSize*10))  
  in 
  let (res,lastBucket,_) = L.fold_left aux ([],(A.create 0 ""),10) ranks in   
  let res = if (A.length lastBucket) > 0 then lastBucket::res else res in
  let res = L.rev res |> L.map (A.enum |- S.of_enum) in
  
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
  
let bucketDynamics: Cranks.day_rank_users -> rates = 
  fun aranks ->
  let bucks = A.map buckets aranks in 
  let bucksEnd  = pred (A.length bucks) in
  let bucksRest = A.sub bucks 1 bucksEnd in
  A.fold_left begin fun (res,prevBucks) bucks ->
    let rates = bucketChangeRates prevBucks bucks in
    leprintf ".";
    (rates::res, bucks)
  end ([],bucks.(0)) bucksRest |> fst |> L.rev