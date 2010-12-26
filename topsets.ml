open Common

type rates = (float list) list
     
module S=Set.StringSet
let floatSize = S.cardinal |- float
     
let buckets ranks = 
  let rec aux (res,lastBucket) bucketSize bucketFill rankedUserLists =
    match rankedUserLists with
      | users::userLists ->
        let chunkSize = L.length users in
        let newBucket = L.append lastBucket users in
        let newSize = bucketFill + chunkSize in
        if newSize < bucketSize 
        then
          aux (res,newBucket) bucketSize newSize userLists
        else
          aux (newBucket::res,[]) (bucketSize*10) 0 userLists
      | _ -> let res = if L.length lastBucket = 0 then lastBucket::res else res in
        L.rev res |> L.map (L.enum |- S.of_enum)
  in aux ([],[]) 10 0 ranks


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