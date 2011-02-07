open Common
open Soc_run_common

type ustats = {
    socUS  : float;
    skewUS : skew;
    dayUS  : int;
    insUS  : talk_balance;
    outsUS : talk_balance;
    totUS  : talk_balance;
    balUS  : talk_balance }

let newUserStats soc day = 
  {socUS = soc; skewUS = []; dayUS = day;
  insUS = H.copy emptyTalk; outsUS = H.copy emptyTalk; 
  totUS = H.copy emptyTalk; balUS  = H.copy emptyTalk }

