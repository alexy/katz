DEBUG=-g
#PROFILE=-p
OPTFLAGS=-inline 100 $(PROFILE)
PACKAGES=batteries,getopt

OC=overclass
RN=rownumber

ALL=$(OC) $(RN)

all: $(ALL:%=%.opt)

%.cmx: %.ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -c $^ -o $@

$(OC).opt: $(OC).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) $^ -o $@

$(RN).opt: $(RN).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
