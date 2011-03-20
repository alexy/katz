open Batteries_uni
open H
open Graph

(* general *)

type ints = int list
type 'a tuple4 = 'a * 'a * 'a * 'a

(* basis *)

type user_int_hash = (user,int) H.t

(* synonyms *)

type dreps = graph

(* by_day *)

type user_user      = (user,reps) H.t
type days           = (user_user * user_user) array
type int_int        = int * int
type int_int_pair   = int_int * int_int
type denums         = (user * int_int) array
type user_nums      = (user, int_int) H.t
type user_nums_pair = user_nums * user_nums
type day_rep_nums   = user_nums array
type day_re_me      = day_rep_nums * day_rep_nums
type day_edgenums   = user_nums_pair array
type user_int       = user * int
type user_ints_enum = user_int E.t
type day_user_ints  = user_int_hash array
type day_user_nums  = user_nums array
type real           = float
type day_real       = day * float
type day_reals      = day_real list
type user_day_reals = (user, day_reals) H.t
type user_reals     = (user, real) H.t
type day_user_reals = user_reals array

(* topsets *)

module S=Set.StringSet
let floatSize = S.cardinal |- float
(* FYI, (float list) list <=> float list list *)
type rates          = (float list) list
type user_set       = S.t
type buckets        = user_set list
type day_buckets    = buckets array


(* cranks *)

type rank           = int
type users          = user list
type rank_users     = users list
type day_rank_users = rank_users array
type day_ranks      = (day * rank) list
type user_day_ranks = (user, day_ranks) H.t
type ranked_users   = users E.t

(* dcaps *)

type cap             = float
type caps            = cap list
type day_caps        = caps array
type user_caps_list  = (user * cap) list
type user_caps_array = (user * cap) array
type day_user_caps   = user_caps_array array
type log_buckets     = (float * int) list
type day_log_buckets = log_buckets array

(* dreps *)

type daily_ints  = (user,(int,int) H.t) H.t
type users_total = user_int_hash
type pair_totals = (user, users_total) H.t

(* dranges *)

type starts = users array

(* volume *)

type bucket_volumes  = ints array
type bucket_volumes2 = (int_int list) array
type bucket_volumes4 = (int_int_pair list) array

(* soc_run *)

type dcaps          = (user, (int * float) list) H.t
type skew           = float list
type dskews         = (user, (int * skew)  list) H.t
type talk_balance   = user_int_hash
type terms_stat     = (float * float * float) option

(* bucket power *)

type staying        = user_int array array
type staying_totals = int array
type b2b            = ints list (* same as int_rates *)
type day_b2b        = b2b array
type int_rates      = ints list   (* TODO rename as: int_table *)
type float3         = float * float * float
type float4         = float * float * float * float
type rates4         = rates * rates * rates * rates
type bucket_numbers = int list
type buckno         = bucket_numbers option

(* starrank *)

type dcaps_hash    = (user,(day,float) H.t) H.t
type starts_hash   = (user,day) H.t
type srank         = float3
type starrank      = (user, (day * srank) list) H.t
type starrank_hash = (user,(day,srank) H.t) H.t
type starbucks     = (float3 * float3) list (* averages * medians *)
type day_starbucks = starbucks array

(* proportional *)

type 'a proportions    = user array * 'a array
type int_proportions   = int proportions
type float_proportions = float proportions

(* fof *)

type udegr = user_int_hash
type fnums = user_int_hash
type fnofs = (user,int_proportions) H.t
type fsocs = (user,float_proportions) H.t

(* moving *)

type bucket_pos   = int
type bucket_track = (bucket_pos * int) list
type bucket_moves = { sinceBM : day; trackBM: bucket_track }
type moving       = (user, bucket_moves) H.t
type moving_ranks = (int * user_set) array

(* Kendall Tau C *)

type big_float = (float, Bigarray.float64_elt, Bigarray.c_layout) Bigarray.Array1.t
