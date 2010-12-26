open Common
open Binary_graph

let () =
  let args = getArgs in
  let (aranksName,ratesPrefix) =
  match args with
    | aranksName::ratesPrefix::restArgs -> (aranksName,ratesPrefix)
    | _ -> failwith "usage: dorates aranksName ratesPrefix"
  in
  leprintfln "reading aranks from %s , saving rates with prefix %s" 
  aranksName ratesPrefix;

  let aranks: Cranks.day_rank_users = loadData aranksName in

  let rates = Topsets.bucketDynamics aranks in
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
  
  saveData rates (ratesPrefix^aranksName)
