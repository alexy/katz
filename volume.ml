open Common
open H.Infix

type bucket_volumes = (int list) array

let bucket_volumes: By_day.day_edgenums -> Cranks.day_rank_users -> bucket_volumes =
  fun denums aranks ->
  assert (A.length denums = A.length aranks);
  let bucks = A.map Topsets.buckets aranks in
  let rnums = A.map (fst |- (H.map (fun _ x -> fst x))) denums in
  let totals = 
  A.map begin fun nreps ->
    H.fold (fun _ n res -> res + n) nreps 0
  end rnums in
  
  A.mapi begin fun day buckets ->
     let dnums = rnums.(day) in
     let bucket_totals = 
     L.map begin fun userset ->
       Topsets.S.fold begin fun user res ->
         res + (H.find_default dnums user 0)
       end userset 0
     end buckets in
     assert (L.sum bucket_totals = totals.(day));
     bucket_totals
  end bucks
  
  (* here, can compute ratios for each bucket over day total *)