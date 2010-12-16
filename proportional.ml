open Common

(* choose members of a hash at random proportionally to their value *)
let rangeLists: By_day.user_int_stream -> (user array * int array) =
  fun uvals ->
  (* first, I wanted to work with enums, but then decided to keep lists inside...
     otherwise, here's how I'd prepend a 0 valued pair to the input stream:
     let uvals0 = E.append (L.enum [("zeroKatzLazarsfeldWattsDodds",0)]) uvals 
     E.push xs x <=> x::xs
     E.empty <=> []
     Array.of_enum
   *)
  let (_,ranges) = E.fold begin fun (tot,res) (u,v) -> 
    let v' = if v > 0 then v else 1 in (* +1 smoothing *)
    let tot' = tot + v' in
    let uv' = (u,tot') in
    (tot',uv'::res)
  end [("zeroKatzLazarsfeldWattsDodds",0)] uvals in
  (* this is Utils.unzip body without rev's, as we have ranges in rev from 
     the first fold! *)
  (* unzip with reverse *)
  let (ul,il) = L.fold_left (fun (xs,ys) (x,y) -> (x::xs,y::ys)) 
    ([],[]) ranges in
  (A.of_list ul, A.of_list il)
  
  
(* find the first element greater than x in a sorted array a *)
let justGreater a x =
    let fromIndex = 0 in
    let uptoIndex = (A.length a) - 1 in
    let fromValue = a.(fromIndex) in
    let uptoValue = a.(uptoIndex) in
    let rec aux fI fV uI uV =
      if x < fV || x > uV then None
      else if fV < x && x <= uV && (succ fI) >= uI then Some uI 
      else begin
        let mI = (fI + uI) / 2 in
        let mV = a.(mI) in
        if x <= mV then aux fI fV mI mV
                   else aux mI mV uI uV
      end in
      aux fromIndex fromValue uptoIndex uptoValue
  
(* bound is precomputed as maximum of a,
   i.e. a's last element, plus 1
   NB: can be an optional parameter *)
let pick a bound =
  (* a |> A.length |> pred |> A.get a, or
    A.backwards |> Enum.peek |> Option.get *)
  let r = Random.int bound in
  justGreater a r