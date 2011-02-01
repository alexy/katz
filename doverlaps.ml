open Common

let () =
  let args = getArgs in
  let (b1Name,b2Name,saveName) =
  match args with
    | b1Name::b2Name::saveName::restArgs -> (b1Name,b2Name,saveName)
    | _ -> failwith "usage: doverlaps b1Name b2Name saveName"
  in
  leprintfln "reading buckets from %s and %s, saving overlaps in %s" 
  b1Name b2Name saveName;

  let b1: day_buckets = loadData b1Name in
  let b2: day_buckets = loadData b2Name in

  let rates: rates = Topsets.bucketOverlapRates b1 b2 in
  leprintfln "";
  
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
  end rates;
  
  saveData rates saveName
