SAVE_GRAPH=save_graph
INVERT_GRAPH=invert_graph
SC=sc
LOOK=look
DEBUG=-g
#PROFILE=-p
OPTFLAGS=-inline 100 $(PROFILE)
PACKAGES=batteries,tokyo_cabinet,otoky,json-wheel,getopt
BYDAY=save_days
STARTS=save_starts
SIM=dosim
SIMF=dosimf
SIMU=dosimu
SIM1=sim
CRANKS=docranks
ARANKS=doaranks
RATES=dorates
SCAPS=save_caps
CBUCKS=docbucks
LBLENS=dolblens
RBLENS=dorblens
SKEW=sk
SGEN=sg
RBUCKS=save_rbucks
VOLS=dovols
VOLS2=dovols2
SAVE_REME=save_reme
OVERLAPS=doverlaps
OVERSETS=doversets
STAY=dostay
TEXR=texrates
B2B=dob2bs
OPT=opt
STARS=dosranks
SBUCKS=dostarbucks
STOV=dostayovers
TEXV=texvols
TEXB2B=texb2bs
TEXSB=texstarbucks
TEX4=tex4rates
TEXLB=texlblens
SU=su
SF=sf
OC=overclass

ALL=$(SAVE_GRAPH) $(INVERT_GRAPH) $(SC) $(LOOK) $(BYDAY) $(STARTS) $(SIM) $(SIMF) $(SIMU) $(SIM1) $(CRANKS) $(ARANKS) $(RATES) $(SCAPS) $(CBUCKS) $(LBLENS) $(RBLENS) $(RBUCKS) $(VOLS) $(VOLS2) $(SAVE_REME) $(OVERLAPS) $(OVERSETS) $(STAY) $(TEXR) $(B2B) $(STARS) $(SBUCKS) $(STOV) $(TEXV) $(TEXB2B) $(TEXSB) $(TEX4) $(TEXLB) $(SKEW) $(SGEN) $(SU) $(SF) $(OC)

all: $(ALL:%=%.opt)

common.cmx: binary_graph.cmx h.cmx utils.cmx t.cmx
load_graph.ml tokyo_graph.ml json_graph.ml: common.ml

%.opt: common.cmx
  
%.cmo %.cmx: %.cmi
  
%.cmo: %.ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -c $^ -o $@

%.cmx: %.ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -c $^ -o $@

#%.cmi: %.mli
#ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -c $^ -o $@
#simulate_utility_fof.cmi: attachment_fof.ml simulate_utility_fof.mli 
#ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -c $^ -o $@ 
#simulate_utility_fof.cmx: simulate_utility_fof.cmi
#simulate_utility_fof.ml: simulate_utility_fof.mli
  
json_graph.cmo: graph.cmo
json_graph.cmx: graph.cmx

tokyo_graph.cmo: json_graph.cmo graph.cmo
tokyo_graph.cmx: json_graph.cmx graph.cmx

soc_run.cmo: dranges.cmo utils.cmo graph.cmo
soc_run.cmx: dranges.cmx utils.cmx graph.cmx

sc.cmx save_starts.cmx: dranges.cmx
invert.cmx by_day.cmx: utils.cmx graph.cmx

simulate.cmx: dreps.cmx proportional.cmx
  
topsets.cmx: cranks.cmx
  
lib: h.cmo graph.cmo utils.cmo binary_graph.cmo t.cmo common.cmo constants.cmo by_day.cmo dranges.cmo dreps.cmo proportional.cmo dcaps.cmo skew.cmo mathy.cmo soc_run_common.cmo
	ocamlfind ocamlc -a -o lib.cma $^

lib.cmxa: h.cmx graph.cmx utils.cmx binary_graph.cmx t.cmx common.cmx constants.cmx by_day.cmx dranges.cmx dreps.cmx proportional.cmx dcaps.cmx skew.cmx mathy.cmx soc_run_common.cmx
	ocamlfind ocamlopt -a -o $@ $^

anygraph.cma:  json_graph.cmo tokyo_graph.cmo load_graph.cmo
	ocamlfind ocamlc -a -o $@ $^
  
anygraph.cmxa: json_graph.cmx tokyo_graph.cmx load_graph.cmx
	ocamlfind ocamlopt -a -o $@ $^
  
sgraph.cmxa: soc_run_common.cmx ustats.cmx sgraph.cmx
	ocamlfind ocamlopt -a -o $@ $^
    
clean:
	rm -f *.cmi *.cmo *.cmx *.o *.opt


$(SAVE_GRAPH).opt: lib.cmxa anygraph.cmxa $(SAVE_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(INVERT_GRAPH).opt: lib.cmxa invert.cmx $(INVERT_GRAPH).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ common.cmx -o $@

$(SC):     lib.cma  anygraph.cma sgraph.cmo soc_run.cmo invert.cmo $(SC).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(SC).opt: lib.cmxa anygraph.cmxa sgraph.cmxa suds.cmx soc_run.cmx invert.cmx $(SC).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(LOOK):      lib.cma $(LOOK).ml
	ocamlfind ocamlc   $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

$(LOOK).opt:  lib.cmxa $(LOOK).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(BYDAY).opt: lib.cmxa json_graph.cmx tokyo_graph.cmx load_graph.cmx $(BYDAY).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SAVE_REME).opt: lib.cmxa $(SAVE_REME).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(STARTS).opt: lib.cmxa anygraph.cmxa invert.cmx $(STARTS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIM).opt:  lib.cmxa invert.cmx simulate.cmx $(SIM).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIMF).opt: lib.cmxa invert.cmx simulate.cmx $(SIMF).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIMU).opt: lib.cmxa invert.cmx simulate.cmx $(SIMU).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIM1).opt: lib.cmxa invert.cmx simulate.cmx $(SIM1).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(CRANKS).opt: lib.cmxa cranks.cmx $(CRANKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(ARANKS).opt: lib.cmxa cranks.cmx $(ARANKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(RATES).opt: lib.cmxa cranks.cmx topsets.cmx $(RATES).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SCAPS).opt: lib.cmxa $(SCAPS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(CBUCKS).opt: lib.cmxa $(CBUCKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(RBUCKS).opt: lib.cmxa topsets.cmx $(RBUCKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(LBLENS).opt: lib.cmxa $(LBLENS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(RBLENS).opt: lib.cmxa bucket_power.cmx $(RBLENS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SKEW).opt: lib.cmxa anygraph.cmxa invert.cmx sgraph.cmxa suds.cmx socday.cmx soc_run_skew.cmx $(SKEW).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SGEN).opt: lib.cmxa invert.cmx simulate.cmx sgraph.cmxa suds.cmx  socday.cmx soc_run_gen.cmx $(SGEN).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(VOLS).opt: lib.cmxa by_day.cmx cranks.cmx topsets.cmx volume.cmx $(VOLS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(VOLS2).opt: lib.cmxa by_day.cmx cranks.cmx topsets.cmx volume.cmx $(VOLS2).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(OVERLAPS).opt: lib.cmxa topsets.cmx $(OVERLAPS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(OVERSETS).opt: lib.cmxa topsets.cmx $(OVERSETS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(STAY).opt: lib.cmxa topsets.cmx bucket_power.cmx $(STAY).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(TEXR).opt: lib.cmxa topsets.cmx teX.cmx $(TEXR).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(B2B).opt: lib.cmxa bucket_power.cmx $(B2B).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(OPT).opt: $(OPT).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(STARS).opt: lib.cmxa starrank.cmx $(STARS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SBUCKS).opt: lib.cmxa starrank.cmx $(SBUCKS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(STOV).opt: lib.cmxa bucket_power.cmx $(STOV).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(TEXV).opt: lib.cmxa teX.cmx $(TEXV).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(TEXB2B).opt: lib.cmxa bucket_power.cmx teX.cmx $(TEXB2B).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(TEXSB).opt: lib.cmxa teX.cmx $(TEXSB).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(TEX4).opt: lib.cmxa teX.cmx $(TEX4).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(TEXLB).opt: lib.cmxa teX.cmx $(TEXLB).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
  
$(SU).opt: lib.cmxa invert.cmx sgraph.cmxa suds_local.cmx socday.cmx attachment_local.cmx simulate_utility_local.cmx soc_run_local.cmx $(SU).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SF).opt: lib.cmxa invert.cmx sgraph.cmxa suds_local.cmx socday.cmx attachment_fof.cmx simulate_utility_fof.cmx soc_run_fof.cmx $(SF).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(OC).opt: $(OC).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) $^ -o $@
  