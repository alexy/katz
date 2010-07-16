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
		 let to_days  = H.find_default res to' (H.create 10) in
		 let to_reps  = H.find_default to_days day (H.create 10) in
		 H.add to_reps from num) reps) days) g;
   res
					    
