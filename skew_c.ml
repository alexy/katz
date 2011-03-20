open Common
open Skew


let kendall_tau_cs ?(usersN=1000000) cd sd =
		let cv = A.map snd cd in
		let c = bigarray_of_array_float cv in
		let ss = H.values sd |> skew_sort_enum in
		let vh = H.create usersN in
		let v = ref 0. in
		A.iter begin fun x ->
			if H.mem vh x then ()
			else begin
				v := !v+.1.;
				vh <-- (x,!v)
				end
		end ss;
		let skew_score user =
			match H.find_option sd user with
			| Some s -> H.find vh s
			| _ -> 0.
		in
		let sv = A.map (fst |- skew_score) cd in
		let s = bigarray_of_array_float sv in
		Kendall_c.tau c s


let kendall_tau_days ?(usersN=1000000) ca dskews =
	let sa  = byDayHash dskews in
	let day = ref 0 in
	A.map2 begin fun cd sd ->
		leprintfln "day %d" !day; incr day;
		kendall_tau_cs ~usersN cd sd
	end ca sa


let kendall_tau_bucks: ?usersN:int -> day_user_caps -> dskews -> rbucks -> day_tau_bucks =
  fun ?(usersN=1000000) ca dskews rbucks ->
	let sa  = byDayHash dskews in
	A.mapi begin fun day buckets ->
		let cd = ca.(day) in
		let sd = sa.(day) in
		L.map begin fun bucket ->
			let cdb = A.filter (fst |- flip S.mem bucket) cd in
			A.sort compPairAsc2 cdb;
			(* no need to filter sd into sdb, it will be used where needed! *)
			kendall_tau_cs ~usersN cdb sd
		end buckets
	end rbucks