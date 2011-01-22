open Common

let () =
  let args = getArgs in
  let (bucksName,ratesPrefix) =
  match args with
    | bucksName::ratesPrefix::restArgs -> (bucksName,ratesPrefix)
    | _ -> failwith "usage: dorates bucksName ratesPrefix"
  in
  leprintfln "reading bucks from %s , saving rates with prefix %s" 
  bucksName ratesPrefix;

  let bucks: Topsets.day_buckets = loadData bucksName in

  let rates = Topsets.bucketDynamics bucks in
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
  
  saveData rates (ratesPrefix^bucksName)
