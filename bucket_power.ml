open Common

let staying bucks =
  let a = A.int 7 (fun i -> let n = power10 i in H.create n) in
  A.iteri begin fun day buckets ->
    L.iteri begin fun i bucket ->
      S.iter begin fun user ->
        hashInc a.(i) (* can store days themselves *)
      end bucket
    end buckets
  end bucks;
  let sa = schwartzSortIntHashDesc a in
  sa
      