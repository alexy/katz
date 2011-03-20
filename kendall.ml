open Common

(* Kendall's Tau
   translated from Incanter *)
   
(*
   
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
(/ ( * 2 dcd)
   ( * n (- n 1)))))

(deftest kendalls-tau-test
  (is (= 23/45
	 (kendalls-tau [4 10 3 1 9 2 6 7 8 5] 
		       [5 8 6 2 10 3 9 4 7 1])))
  (is (= 9/13
	 (kendalls-tau
	  [1 3 2 4 5 8 6 7 13 10 12 11 9]
	  [1 4 3 2 7 5 6 8 9 10 12 13 11]))))   
   
*)

let tau1 ?(sort=false) ?(comp=compare) x y =
	let less,greater = lt_gt_of comp in	
	let     n = A.length x in
	assert (n = A.length y);
	let a = A.map2 (fun x y -> (x,y)) x y in
	if sort then  A.sort compPairAsc1 a else ();
	let _,dcd = A.fold_left begin fun (vals,total) (_,v) ->
		let lt   = L.filter (less    v) vals |> L.length in
		let gt   = L.filter (greater v) vals |> L.length in
		let diff = gt - lt in
		(* NB can we enumerate over A prefix, in second, and not allocate vals at all? *)
		v::vals, total + diff
	end ([],0) a in
	let n' = float n in
	(float dcd) *. 2. /. (n' *. (n' -. 1.))


let countPrefix a n v f =
	A.enum a |> E.take n |> E.filter (f v) |> E.count
	

let tau2 ?(sort=false) ?(comp=compare) x y =
	let less,greater = lt_gt_of comp in	
	let     n = A.length x in
	assert (n = A.length y);
	let a = A.map2 (fun x y -> (x,y)) x y in
	let y = if sort then begin
		A.sort compPairAsc1 a; 
		A.map snd a
		end
	else y in
	let _,dcd = A.fold_left begin fun (n,total) (_,v) ->
		let scan = countPrefix y n v in
		let lt   = scan (<) in
		let gt   = scan (>) in
		let diff = gt - lt in
		(* NB can we enumerate over A prefix, in second, and not allocate vals at all? *)
		succ n, total + diff
	end (0,0) a in
	let n' = float n in
	(float dcd) *. 2. /. (n' *. (n' -. 1.))


let kendall_tau_test: (?sort:bool -> ?comp:('b -> 'b -> int) -> 'a array -> 'b array -> float) -> unit =
	fun f ->
	let sort = true in
	assert begin
		f ~sort [|4;10;3;1;9;2;6;7;8;5|]
            [|5;8;6;2;10;3;9;4;7;1|]
		= 23./.45.
	end;
	assert begin
	  f ~sort [|1;3;2;4;5;8;6;7;13;10;12;11;9|]
            [|1;4;3;2;7;5;6;8;9;10;12;13;11|]
		= 9./.13.
	end