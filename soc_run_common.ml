open Common
let getUserDay = Dreps.getUserDay

type dCaps  = (user, (int * float) list) H.t

type skew   = float list
type dSkews = (user,(int * skew)  list) H.t

type talkBalance = (user,int) H.t
let emptyTalk : talkBalance = H.create Constants.repsN

type userStats = {
    socUS  : float;
    skewUS : skew;
    dayUS  : int;
    insUS  : talkBalance;
    outsUS : talkBalance;
    totUS  : talkBalance;
    balUS  : talkBalance }

let newUserStats soc day = 
  {socUS = soc; skewUS = []; dayUS = day;
  insUS = H.copy emptyTalk; outsUS = H.copy emptyTalk; 
  totUS = H.copy emptyTalk; balUS =  H.copy emptyTalk }

type uStats = (user,userStats) H.t

(* let safeDivide x y = let res = if y == 0. then x else x /. y in
	let show what = Printf.sprintf "%s in safeDivide => x: %e, y: %e, res: %e, y == 0.: %B" 
		what x y res (y==0.) in
	begin match classify_float res with
		| FP_nan -> failwith (show "nan")
		| FP_infinite -> failwith (show "infinite")
		| _ -> res end *)

(* TODO convert to an object or nested record, like
alexyk: I need to have a function which is called with a record type.  I later redefine the type in different modules, adding fields; but I'm calling the function only with a minimal subset of fields.  Is there a way to do it with records, or I'd have to use OO?
[5:06pm] thelema: sorry, you need OO for that - ocaml's records don't nest
[5:13pm] mrvn: they do but really ugly.
[5:14pm] alexyk: so if I'm replacing a record with a class; how can I pattern-match an object on value  field names, to achieve the same effect as {field1 =v1; field2 =v2} = recval?
[5:14pm] thelema: well, you can put records within records, but you can't do subtyping between record types in the nice way - passing {a=2;b=3} to (fun {a=a} -> a+1)
[5:14pm] mrvn: alexyk: Option 1) Obj.magic. 2) extendable records type 'a foo = { x:int; data:'a }
[5:15pm] alexyk: ok...
[5:15pm] mrvn: alexyk: no pattern matching on members of a class
[5:15pm] alexyk: mrvn: so a series of extractions, rcval#field1, ... only?
[5:16pm] mrvn: alexyk: which you can put into a match again if you like
[5:18pm] mrvn: In my B-Tree I have type key_type = One | Two  type key = { key_type : key_type; hash : int } and type 'a leaf = { key_type : key_type; hash : int; data : 'a } and I have functions to_key and from_key
ulfdoz left the chat room. (Ping timeout: 276 seconds)
[5:34pm] alexyk: can records have default values?
[5:36pm] alexyk: for fields
[5:36pm] thelema: no
[5:37pm] thelema: use a constructor function to do that.
 --
 for now, we'll just backport dskewsSG into soc_run.ml
 *)
		
type sGraph = 
  {drepsSG : graph; dmentsSG : graph; 
   dcapsSG : dCaps; dskewsSG : dSkews;
   ustatsSG : uStats}

let safeDivide3 (x,y,z) (x',y',z') =
  let a = safeDivide x x' in
  let b = safeDivide y y' in
  let c = safeDivide z z' in
  (a,b,c)

type termsStat = (float * float * float) option

type timings = float list

let getSocCap ustats user =
  match H.find_option ustats user with
    | Some stats -> stats.socUS
    | _ -> 0.
    
(* updates stats in the original ustats! *)
let socUserDaySum (* : sGraph -> day -> user -> userStats -> termsStat = fun *) sgraph day user stats (* -> *) =
  let {drepsSG=dreps;dmentsSG=dments;ustatsSG=ustats} = sgraph in
  let dr_ = getUserDay user day dreps in
  let dm_ = getUserDay user day dments in
  (* TODO with open Option just locally -- possible? *)
  if not (Option.is_some dr_ || Option.is_some dm_) then
    None
  else (* begin..end extraneous around the let chain? *)
    (* NB: don't match dayUS=day, it will shadow the day parameter! *)
    let {socUS =soc; insUS =ins; outsUS =outs; totUS =tot; balUS =bal} = stats in
    
    let outSum =
      match dr_ with
        | None -> 0.
        | Some dr ->
        	(* leprintf "user: %s, dr size: %d" user (H.length dr); *)
            let step to' num res = 
              let toBal = H.find_default bal to' 0 in
              if toBal >= 0 then res
              else begin (* although else binds closer, good to demarcate *)
                let toSoc = getSocCap ustats to' in
                  if toSoc = 0. then res
                  else
                    let toOut = H.find_default outs to' 1 in
                    let toTot = H.find_default tot  to' 1 in
                    let term = float (num * toBal * toOut) *. toSoc /. float toTot in
                    res -. term (* the term is negative, so we sum positive *)
              end
            in
            H.fold step dr 0. in

    let (inSumBack,inSumAll) =
          match dm_ with
            | None -> (0.,0.)
            | Some dm ->
                let step to' num ((backSum,allSum) as res) =
                  let toSoc = getSocCap ustats to' in
                  if toSoc = 0. then res
                  else begin
                    let toIn  = H.find_default ins to' 1 in
                    let toTot = H.find_default tot to' 1 in
                    let allTerm  = float (num * toIn) *. toSoc /. float toTot in
                    let toBal = H.find_default bal to' 0 in
                    let backTerm = if toBal <= 0 then 0. else float toBal *. allTerm in
                    (backSum +. backTerm,allSum +. allTerm)
                  end
                in  
                H.fold step dm (0.,0.) in

    let terms = (outSum, 
                 inSumBack, 
                 inSumAll) in

     (* flux suggested this HOF to simplify match delineation: *)
    let call_some f v = match v with None -> () | Some v -> f v in
    call_some (addMaps ins)  dr_;
    call_some (addMaps outs) dm_;
    begin match (dr_, dm_) with
      | (Some dr, None) ->     addMaps tot dr; addMaps      bal dr 
      | (None, Some dm) ->     addMaps tot dm; subtractMaps bal dm 
      | (Some dr, Some dm) ->  addMaps tot dr; addMaps      tot dm;
                               addMaps bal dr; subtractMaps bal dm
      | (None,None) -> () end; (* should never be reached in this top-level if's branch *)
    Some terms


let socDaySkew sgraph params day =
  let (alpha, beta, gamma, by_mass, skew_times) = params in
  let {ustatsSG =ustats; dcapsSG =dcaps; dskewsSG =dskews} = sgraph in
    (* or is it faster to dot fields:
    let ustats = sgraph.ustatsSG in
    let dcaps  = sgraph.dcapsSG in *)

  (* TODO how do we employ const |_ ... instead of the lambda below? *)
  let termsStats = H.map (socUserDaySum sgraph day) ustats in
  let sumTerms   = termsStats |> H.values |> enumCatMaybes in
  let (outSum,inSumBack,inSumAll) as norms = Enum.fold (fun (x,y,z) (x',y',z') -> (x+.x',y+.y',z+.z')) 
                        (0.,0.,0.) sumTerms in
  leprintfln "day %d norms: [%F %F %F]" day outSum inSumBack inSumAll;

  (* : user -> ((float * float * float) option * userStats) -> userStats *)
  let tick : user -> userStats -> termsStat -> userStats = 
    fun user stats numers ->
    let {socUS =soc; insUS =ins; outsUS =outs} = stats in
    let soc' = 
          match numers with
            | Some numers ->
              let (outs', insBack', insAll') =
                   safeDivide3 numers norms 
              in
              alpha *. soc +. (1. -. alpha) *.
                (beta *. outs' +. (1. -. beta) *.
                  (gamma *. insBack' +. (1. -. gamma) *. insAll'))
            | None -> alpha *. soc in
    let stats' = {stats with socUS = soc'} in
    
    (* TODO we might just keep the pairs as yet anotehr hastbatle;
       we may then finally optimize data structure by sharing inverted pairs...
     *)

    let stats' = 
    if H.length ins = 0 then stats'
    else begin
      let rewards_contributions = H.map begin fun mentioner nments -> 
        let nreps = H.find_default outs mentioner 0 in
        (nreps,nments) 
      end ins |> H.values |> A.of_enum in

      A.sort (fun (_,x) (_,y) -> compare y x) rewards_contributions;
      let rewards, contributions = Utils.array_split rewards_contributions in
      let skew'  = Skew.skew ~by_mass ~skew_times rewards contributions in
      {stats' with skewUS = skew'}
    end in
    stats' in
    
  hashUpdateWithImp tick ustats termsStats;
  
  let updateUser dcaps dskews user stats  =
    let {socUS =soc; skewUS = skew} = stats in
    let caps  = H.find_default dcaps user [] in
    let caps' = (day,soc)::caps in
    H.replace dcaps user caps';
    if skew = []  then ()
    else
      let skews  = H.find_default dskews user [] in
      let skews' = (day,skew)::skews in
      H.replace dskews user skews' in

  H.iter (updateUser dcaps dskews) ustats
