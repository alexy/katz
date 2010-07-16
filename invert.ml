open Batteries_uni
open Graph
module H=Hashtbl

let invert1 : graph -> graph = fun g ->
  let res = H.create (H.length g) in
  H.iter 
    (fun from days -> 
       H.iter 
	 (fun day reps -> 
	    H.iter 
	      (fun to' num -> 
		 let to_days  = match H.find_option res to' with
		   | Some x -> x
		   | _ -> let x: adjlist = H.create 10 in H.add res to' x; x in
		 let to_reps  = match H.find_option to_days day with
		   | Some x -> x
		   | _ -> let x: reps = H.create 10 in H.add to_days day x; x in
		 H.add to_reps from num) reps) days) g;
   res

(*					    
let invert2 : graph -> graph = fun g ->
  let res = H.enum g in
  Enum.map (fun (from, days) -> let days' = H.enum days in
	      Enum.map (fun (day,reps) -> let reps' = H.enum reps in
			  Enum.map (fun (to',num) -> (to',(day,from,num))
 ...*)
