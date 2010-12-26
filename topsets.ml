open Common

type rates = (float list) list
     
module S=Set.StringSet
let floatSize = S.cardinal |- float
let set_of_list = L.enum |- S.of_enum
     
let buckets ranks = 
  let rec aux (res,lastBucket) bucketSize rankedUserLists =
    match rankedUserLists with
      | users::userLists ->
        let newBucket = S.union lastBucket (set_of_list users) in
        if (S.cardinal newBucket) < bucketSize 
        then
          aux (res,newBucket) bucketSize userLists
        else
          aux (newBucket::res,S.empty) (bucketSize*10) userLists
      | _ -> let res = if S.cardinal lastBucket > 0 then lastBucket::res else res in
        L.rev res
  in 
  let res = aux ([],S.empty) 10 ranks in
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