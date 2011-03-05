open Common
          
let buckets: rank_users -> buckets =
  fun ranks ->
  let aux (res, bucket, used, bucketSize) users =
    let usersLength = L.length users in
    let newUsed = used + usersLength in
    if newUsed <= bucketSize 
      then begin
        L.iteri (fun i x -> bucket.(used+i) <- x) users;
        (res, bucket, newUsed, bucketSize)
      end
      else
      let pwr10 n start res =
        let rec exceed n acc res =
          if acc > n then (acc,res)
          else exceed n (acc*10) ([||]::res) in
          exceed n start res in
      let (newBucketSize,res) = pwr10 usersLength (bucketSize*10) (bucket::res) in
      let newBucket = A.append (A.of_list users) 
        (A.create (newBucketSize - usersLength) "") in
      (res, newBucket, usersLength, newBucketSize)  
  in 
  let (res, lastBucket, _, _) = L.fold_left aux ([], A.create 10 "", 0, 10) ranks in   
  let res = if (A.length lastBucket) > 0 then lastBucket::res else res in
  (* TODO: either carry used size for each bucket and A.sub before
     converting to the set, or simply subtract "" form the set! *)
  let res = L.rev res |> L.map (A.enum |- S.of_enum |- S.remove "") in
  
  leprintf "buckets size: %d " (L.length res);
  List.print Int.print stderr (L.map S.cardinal res |> L.take 20);
  leprintfLn;
  res


let bucketChangeRates bs1 bs2 =
  let rec aux bs1 bs2 acc = 
    match bs1,bs2 with
    | b1::bs1,b2::bs2 -> 
      let inter = S.inter b1 b2 in
      let stayRate = (floatSize inter) /. (floatSize b1) in
      aux bs1 bs2 (stayRate::acc)
    | _ -> L.rev acc
  in
  aux bs1 bs2 []

  
let bucketDynamics: day_buckets -> rates = 
  fun bucks ->
  let bucksEnd  = pred (A.length bucks) in
  let bucksRest = A.sub bucks 1 bucksEnd in
  A.fold_left begin fun (res,prevBucks) bucks ->
    let rates = bucketChangeRates prevBucks bucks in
    leprintf ".";
    (rates::res, bucks)
  end ([],bucks.(0)) bucksRest |> fst |> L.rev
  
  
let bucketOverlapRates: day_buckets -> day_buckets -> rates =
  fun b1 b2 ->
  A.map2 begin fun db1 db2 ->
      bucketChangeRates db1 db2
  end b1 b2 |> list_of_array
  
  
let bucketOverlapSetsRatios: day_buckets -> day_buckets -> day_buckets * rates * rates =
  fun b1 b2 ->
  let rec aux xx yy acc_set acc_inx acc_iny =
    match xx,yy with
    | x::xs,y::ys -> 
        let inter = S.inter x y in
        let inx = (floatSize inter) /. (floatSize x) in
        let iny = (floatSize inter) /. (floatSize y) in
      aux xs ys (inter::acc_set) (inx::acc_inx) (iny::acc_iny)
    | _ ->(L.rev acc_set,L.rev acc_inx,L.rev acc_iny)
    in
  let a3 = A.map2 begin fun db1 db2 ->
      aux db1 db2 [] [] []
  end b1 b2 in
  let os,ox,oy = array_split3 a3 in
  os, list_of_array ox, list_of_array oy
  

let show_rates rates =
  L.iter begin fun rate ->
    if (L.length rate) < 50 
    then
      (* this works in repl under batteries, but p is not defined in compilation!
      http://dutherenverseauborddelatable.wordpress.com/2009/04/06/ocaml-batteries-included-beta-1/       
      Print.printf p"%{float list}\n" rate
      TODO: add, to ocamlfind,
      -syntax camlp4 -package batteries.syntax
      *)
      begin
      L.iter (printf " %f") rate;
      printf "\n"
      end
    else
      leprintfln "rate has wrongfully enormous length %d" (L.length rate)
  end rates
