open Common

let bucket_volumes: bool -> day_user_ints -> day_buckets -> bucket_volumes =
  fun checkSums rnums bucks ->
  assert (A.length rnums = A.length bucks);
  let totals = 
  A.map begin fun nreps ->
    H.fold (fun _ n res -> res + n) nreps 0
  end rnums in
  
  A.mapi begin fun day buckets ->
     let dnums = rnums.(day) in
     let bucket_totals = 
     L.map begin fun userset ->
       S.fold begin fun user res ->
         res + (H.find_default dnums user 0)
       end userset 0
     end buckets in
     
     (* assert (L.sum bucket_totals = totals.(day)); *)
     let sum_buckets = L.sum bucket_totals in
     
     if checkSums then
     begin match sum_buckets = totals.(day) with
     | true -> ()
     | false -> 
       let bucket_users        = L.fold_left S.union S.empty buckets in
       let bucket_user_num     = S.cardinal bucket_users in
       let denums_users        = H.keys dnums |> S.of_enum in
       let denums_users_num    = S.cardinal bucket_users in
       let denums_not_buckets  = S.diff denums_users bucket_users in
       let denums_not_buckets_num = S.cardinal denums_not_buckets in
       let buckets_not_denums  = S.diff bucket_users denums_users in
       let buckets_not_denums_num = S.cardinal buckets_not_denums in
       failwith (sprintf ("sum bucket_totals, %d /= %d, denums total for the day %d\n"^^
                         "total bucket users: %d, total denums users: %d\n"^^
                         "denums not in buckets: %d, buckets not in denums: %d")
       sum_buckets totals.(day) day 
       bucket_user_num denums_users_num 
       denums_not_buckets_num buckets_not_denums_num)
     end
     else ();
     bucket_totals
  end bucks


let bucket_volumes2: bool -> day_user_nums -> day_buckets -> bucket_volumes2 =
  fun checkSums rnums bucks ->
    
  assert begin A.length rnums = A.length bucks end;
  let totals = 
  A.map begin fun nreps ->
    H.fold begin fun _ (nt,nu) (tsum,usum) -> 
      tsum+nt,usum+nu 
    end nreps (0,0)
  end rnums in
  
  A.mapi begin fun day buckets ->
     let dnums = rnums.(day) in
     let bucket_totals = 
     L.map begin fun bucket ->
       S.fold begin fun user (tsum,usum) ->
         let nt,nu = H.find_default dnums user (0,0) in
         tsum+nt,usum+nu
       end bucket (0,0)
     end buckets in
        
     let tsum_buckets = bucket_totals |> L.map fst |> L.sum in
     let usum_buckets = bucket_totals |> L.map snd |> L.sum in
     let tsum_dnums,usum_dnums = totals.(day) in
     
     if checkSums then
     begin match tsum_buckets = tsum_dnums, 
                 usum_buckets = usum_dnums with
     | true,true -> ()
     | _ -> 
       let bucket_users        = L.fold_left S.union S.empty buckets in
       let bucket_user_num     = S.cardinal bucket_users in
       let denums_users        = H.keys dnums |> S.of_enum in
       let denums_users_num    = S.cardinal bucket_users in
       let denums_not_buckets  = S.diff denums_users bucket_users in
       let denums_not_buckets_num = S.cardinal denums_not_buckets in
       let buckets_not_denums  = S.diff bucket_users denums_users in
       let buckets_not_denums_num = S.cardinal buckets_not_denums in
       failwith begin sprintf ("CHECKSUM FAILURE: tsum_buckets-> %s <-tsum_dnums\n"^^
                               "                  usum_buckets-> %s <-usum_dnums, day %d\n"^^
                         "total bucket users: %d, total denums users: %d\n"^^
                         "denums not in buckets: %d, buckets not in denums: %d")
                 (show_equals tsum_buckets tsum_dnums)
                 (show_equals usum_buckets usum_dnums) day 
                 bucket_user_num denums_users_num 
                 denums_not_buckets_num buckets_not_denums_num 
       end
     end
     else ();
     bucket_totals
  end bucks
  
  (* here, can compute ratios for each bucket over day total *)