#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/signals.h>
#include <caml/bigarray.h>
#include "kendall/tau.h"

value kendall_tau(value a, value b) {
	CAMLparam2(a,b);
	int len = Bigarray_val(a)->dim[0];
	double ktau = kendallNlogN(Data_bigarray_val(a),Data_bigarray_val(b),len);
	CAMLreturn (Val_double(ktau));
}