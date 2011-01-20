open Common
open H.Infix

type bucket_volumes = (int list) array

let bucket_volumes: By_day.day_user_ints -> Topsets.day_buckets -> bucket_volumes =
  fun rnums bucks ->
  assert (A.length rnums = A.length bucks);
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
     
     (* assert (L.sum bucket_totals = totals.(day)); *)
     let sum_buckets = L.sum bucket_totals in
     begin match sum_buckets = totals.(day) with
     | true -> ()
     | false -> failwith (sprintf "sum bucket_totals, %d /= %d, denums total for the day"
                sum_buckets totals.(day))
     end;
     bucket_totals
  end bucks
  
  (* here, can compute ratios for each bucket over day total *)