open Common

(* choose members of a hash at random proportionally to their value *)
let rangeLists =
  fun add smooth zero uvals ->
  (* first, I wanted to work with enums, but then decided to keep lists inside...
     otherwise, here's how I'd prepend a 0 valued pair to the input stream:
     let uvals0 = E.append (L.enum [("zeroKatzLazarsfeldWattsDodds",0)]) uvals 
     E.push xs x <=> x::xs
     E.empty <=> []
     Array.of_enum
   *)
  let (_,ranges) = E.fold begin fun (tot,res) (u,v) -> 
    let v' = if v > zero then v else smooth in (* +1 smoothing *)
    let tot' = add tot v' in
    let uv' = (u,tot') in
    (tot',uv'::res)
  end (zero,[("zeroKatzLazarsfeldWattsDodds",zero)]) uvals in
  (* this is Utils.unzip body without rev's, as we have ranges in rev from 
     the first fold! *)
  (* unzip with reverse *)
  let (ul,il) = L.fold_left (fun (xs,ys) (x,y) -> (x::xs,y::ys)) 
    ([],[]) ranges in
  (A.of_list ul, A.of_list il)
  
  
(* find the first element greater or equal than x in a sorted array a *)
  
let binarySearch aux a ?from ?upto x =
  let fromIndex = match from with Some x -> x | _ -> 0 in
  let uptoIndex = match upto with Some x -> x | _ -> (A.length a) - 1 in
  let fromValue = a.(fromIndex) in
  let uptoValue = a.(uptoIndex) in
  aux a fromIndex fromValue uptoIndex uptoValue x

let rec findGreaterOrEqual a fI fV uI uV x =
  if x < fV || x > uV 
    then None
    else if fV < x && x <= uV && (succ fI) >= uI 
      then Some uI 
      else 
        let mI = (fI + uI) / 2 in
        let mV = a.(mI) in
        if x = mV 
          then Some mI
          else if x < mV 
            then findGreaterOrEqual a fI fV mI mV x
            else findGreaterOrEqual a mI mV uI uV x

let rec findGreater a fI fV uI uV x =
  if x >= uV then None
  else if fV <= x && x < uV && (succ fI) >= uI then Some uI 
  else begin
    let mI = (fI + uI) / 2 in
    let mV = a.(mI) in
    if x < mV then findGreater a fI fV mI mV x
              else findGreater a mI mV uI uV x
  end

let justGE      a = binarySearch findGreaterOrEqual a
let justGreater a = binarySearch findGreater        a
  
(* bound is precomputed as maximum of a,
   i.e. a's last element, plus 1
   NB: can be an optional parameter *)
let pickInt a bound =
  (* a |> A.length |> pred |> A.get a, or
    A.backwards |> Enum.peek |> Option.get *)
  let r = Random.int bound in
  justGE a r

let pickReal a bound =
  let r = Random.float bound in
  justGE a r

(* NB doesn't type:
let pick isReal a bound =
  if isReal then pickReal a bound
  else pickInt a bound
 *)  