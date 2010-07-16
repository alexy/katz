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
		 let to_days  = H.find_default res to' 
		   (let x: adjlist = H.create 10 in H.add res to' x; x) in
		 let to_reps  = H.find_default to_days day 
		   (let x: reps = H.create 10 in H.add to_days day x; x) in
		 H.add to_reps from num) reps) days) g;
   res
					    
