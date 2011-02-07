(defn kendalls-tau
"
http://en.wikipedia.org/wiki/Kendall_tau_rank_correlation_coefficient
http://www.statsdirect.com/help/nonparametric_methods/kend.htm
http://mail.scipy.org/pipermail/scipy-dev/2009-March/011589.html
best explanation and example is in \"cluster analysis for researchers\" page 165.
http://www.amazon.com/Cluster-Analysis-Researchers-Charles-Romesburg/dp/1411606175
"
[a b]
(let [_ (assert (= (count a) (count b)))
      n (count a)
      ranked (reverse (sort-map (zipmap a b)))
      ;;dcd is the meat of the calculation, the difference between the doncordant and discordant pairs
      dcd (second
           (reduce
           (fn [[vals total] [k v]]
             (let [diff (- (count (filter #(> % v) vals))
                           (count (filter #(< % v) vals)))]
               [(conj vals v) (+ total diff)]))
           [[] 0]
           ranked))]
(/ (* 2 dcd)
   (* n (- n 1)))))
   
;; *) *)

(* ab is an array of pairs, sorted descending by b *)
let kendall_tau ab =
  let dcd = A.fold_left begin fun (bs,total) (a,b) ->
    let num_gt = L.filter ((>) a) as |> L.length in 
    let num_lt = L.filter ((<) a) as |> L.length in 
    let diff   = num_gt - num_lt in
    (a::as)