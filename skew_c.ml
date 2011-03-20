open Common
open Skew


let kendall_tau_cs ?(usersN=1000000) cd ?(limit=false) ?se sd =
		let se = match se with
		| Some e -> e |> E.map snd
		| _ when limit ->
			let cusers = A.enum cd |> E.map fst |> S.of_enum in			
			H.enum sd |> E.filter (fst |- flip S.mem cusers) |> 
			E.map snd
		| _ -> H.values sd
		in
		let ss = skew_sort_enum se in
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
		let cv = A.map snd cd in
		let c = bigarray_of_array_float cv in
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
	let limit=true in
	A.mapi begin fun day buckets ->
		leprintfln "day %d" day;
		let cd = ca.(day) in
		let sd = sa.(day) in
		L.map begin fun bucket ->
			let cdb = A.filter (fst |- flip S.mem bucket) cd in
			A.sort compPairAsc2 cdb;
			let se = H.enum sd |> E.filter (fst |- flip S.mem bucket) in
			kendall_tau_cs ~usersN cdb ~limit ~se sd
		end buckets
	end rbucks