open Common
open Soc_run_common

type ustats = {
    socUS  : float;
    dayUS  : int;
    insUS  : talk_balance;
    outsUS : talk_balance;
    totUS  : talk_balance;
    balUS  : talk_balance }

let newUserStats soc day = 
  {socUS = soc; dayUS = day;
  insUS = H.copy emptyTalk; outsUS = H.copy emptyTalk; 
  totUS = H.copy emptyTalk; balUS  = H.copy emptyTalk }

type user_stats = (user,ustats) H.t

let statSoc {socUS =soc} = soc

let getSocCap ustats user =
  match H.find_option ustats user with
    | Some stats -> stats.socUS
    | _ -> 0. 

(* create a real-valued list for users to attach proportionally,
   normalizes just the last cap and returns the last ones only *)
let mature_caps minDays minCap ustats day =
  H.map begin fun user {socUS=cap;dayUS=sinceDay} ->
    if day - sinceDay < minDays then minCap
    else cap
  end ustats

