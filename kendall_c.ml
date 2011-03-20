open Common

external tau: big_float -> big_float -> float = "kendall_tau"

let tau_array: float array -> float array -> float =
	fun a b ->
	let ba = bigarray_of_array_float a in
	let bb = bigarray_of_array_float b in
	tau ba bb