(* given a sorted list of contributions, C, from distinct contributors, one per each, 
   and a list of rewards, R, corresponding to each contributor, we define our qpq-city,
   or quod-pro-quo-dness, or just qpq measure, as follows.
   
   find the midpoint in array C where the left and the right parts will have about equal weight in
   C, C2_l and C2_r.  Index-wise corresopnding parts are R2_l and R2_r.
   
   Let Q2 = R2_l/R2_r.
   
   Now focus on C2_l as a bnew C, and compute a similar metric only for that, calling it Q4.
   
   Repeat a few times N.  Collect the resulting vector [|Q2;Q4...;Q2^N|] -- this is qpq.
   
   
 *)
 
open Common

let gather from upto limit a =
  let rec aux i acc = 
    (* NB i returned begins the next chunk!
       if you want acc's last, return pred i *)
    if acc >= limit  then Some (acc,i)
    else if i > upto then None
    else aux (succ i) (acc + a.(i)) 
  in
  aux from 0
      

let midpoint by_mass from upto a =
 if by_mass 
 then begin
   let total = sum_range ~from ~upto a in
   let middle = total / 2 in
   gather from upto middle a
 end
 else
   if upto > from then Some (0, (upto + from + 1) / 2)
   else None
   
 
let skew ?(by_mass=false) ?(skew_times=4) a b =
  let rec aux from upto i res =
    if from + 1 >= upto then res
    (* if from >= upto then res *)
    else begin
    match midpoint by_mass from upto b with
    | Some (_,m) when m > 0 ->
      let left = pred m in
      if from >= left || left > upto then res
      else begin
        let al = sum_range ~from ~upto:left a in
        let ar = sum_range ~from:m ~upto a in
        if al = 0 && ar = 0 then res 
        else begin 
          let r = if ar > 0 then (float al) /. (float ar) else (-1.) in
          if i < skew_times then aux from left (succ i) (r::res)
          else res
        end
      end
    | _ -> res
  end in
  let from = 0 in
  let upto = A.length b - 1 in
  let res  = aux from upto 0 [] in
  L.rev res


(* let test_skew () =
  let b  = [|8;7;6;5;2;3;1;1|] in
  let a1 = [|5;10;6;7;4;3;2;1|] in
  let a2 = [|10;9;8;7;6;5;4;3|] in
  let a3 = [|3;4;5;6;7;8;9;10|] in
  let a4 = [|8;7;6;5;4;3;2;1|] in
  let a5 = [|1;2;3;4;5;6;7;8|] in
  skew a1 b *)
  
  
let rec compareSkew ?(lengthFirst=true) xs ys =
	let rec aux xs ys =
		match xs,ys with
		| x::xs,y::ys when x = -1. && y = -1. ->
			compare xs ys
		| x::xs,y::ys when x = -1.            ->  1
		| x::xs,y::ys when            y = -1. -> -1
		| x::xs,y::ys                         -> 
			let c = compare x y in if c = 0 then compare xs ys else c
		| x::xs,_                             ->  1
		| _,y::ys                             -> -1
		| _                                   ->  0
	in
	if lengthFirst then begin
		let c = compare (L.length xs) (L.length ys) in
		if c <> 0 then c else aux xs ys
		end
	else
		aux xs ys

let skew_sort: skew list -> skew array =
	fun skew ->
	let a = A.of_list skew in
	A.sort compareSkew a;
	a
	
	
let byDay: ?daysN:int -> (user, (day * 'a) list) H.t -> (user * 'a) list array =
	fun ?(daysN=10) ds ->
	let h = H.create daysN in
	H.iter begin fun user day_xs ->
		L.iter begin fun (day,x) ->
			H.replace h day ((user,x)::(H.find_default h day []))
		end day_xs
	end ds;
	let maxDay = H.keys h |> L.of_enum |> L.max in
	A.init (succ maxDay) (fun i -> H.find_default h i [])


let byDayHash: ?daysN:int -> ?usersN:int -> (user, (day * 'a) list) H.t -> (user,'a) H.t array =
	fun ?(daysN=10) ?(usersN=1000000) ds ->
	let h = H.create daysN in
	H.iter begin fun user day_xs ->
		L.iter begin fun (day,x) ->
			let dh = try H.find h day 
			with Not_found -> let dh = H.create usersN in begin H.add h day dh; dh end in
			H.add dh user x (* user should not have been present *)
		end day_xs
	end ds;
	let maxDay = H.keys h |> L.of_enum |> L.max in
	A.init (succ maxDay) (fun i -> H.find_default h i (H.create 0))


let sort_dskews dskews =
	byDay dskews |>
	A.map begin fun x -> 
		let a = A.of_list x in 
		A.sort (do_seconds compareSkew) a; 
		a
	end
	
	
let sort_dcaps dcaps =
	byDay dcaps |>
	A.map begin fun x ->
		let a = A.of_list x in 
		A.sort compPairAsc2 a; 
		a
	end
	
	
let kendall_tau dcaps dskews =
	let ca = sort_dcaps  dcaps  in
	let sa = byDayHash   dskews in
	let r = A.map2 begin fun c s ->
		let cv = A.map snd c in
		let sv = A.map fst c |> A.map (hash_find_warn_kstr [] s) in
		leprintf ".";
		Kendall.tau2 ~comp:compareSkew cv sv
	end ca sa in
	le_newline;
	r