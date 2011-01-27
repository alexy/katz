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