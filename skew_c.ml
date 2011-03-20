open Common
open Skew

let kendall_tau ?(usersN=1000000) dcaps dskews =
	let ca = sort_dcaps  dcaps  in
	let sa = byDayHash   dskews in
	A.map2 begin fun cd sd ->
		let cv = A.map snd cd in
		let c = Bigarray.Array1.of_array Bigarray.float64 Bigarray.c_layout cv in
		let ss = H.values sd |> skew_sort_enum in
		let vh = H.create usersN in
		let v = ref 0. in
		let day = ref 0 in
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
		let sv = A.map fst cd |> A.map skew_score in
		let s = Bigarray.Array1.of_array Bigarray.float64 Bigarray.c_layout sv in
		leprintfln "day %d" !day; incr day;
		Kendall_c.tau c s
	end ca sa
