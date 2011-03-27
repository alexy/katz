#CC=/usr/bin/gcc-4.2
DEBUG=-g
#SHARED=-shared
#PROFILE=-p
OPTFLAGS=-inline 100 $(PROFILE)
PACKAGES=batteries,tokyo_cabinet,otoky,json-wheel,getopt,unix,bigarray,mikmatch_pcre

SAVE_GRAPH=save_graph
INVERT_GRAPH=invert_graph
SC=sc
LOOK=look
BYDAY=save_days
STARTS=save_starts
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
MOVE=domoves
SKA=doska
SKABS=doskabs
USKA=uberdoska
TEXT=textau
DFCB=dataframe

KENDALL_C_OBJ=kendall/tau.o kendall_tau.o 

ALL=$(SAVE_GRAPH) $(INVERT_GRAPH) $(SC) $(LOOK) $(BYDAY) $(STARTS) $(SIM1) \
    $(CRANKS) $(ARANKS) $(RATES) $(SCAPS) $(CBUCKS) $(LBLENS) $(RBLENS) \
    $(RBUCKS) $(VOLS) $(VOLS2) $(SAVE_REME) $(OVERLAPS) $(OVERSETS) $(STAY) \
    $(TEXR) $(B2B) $(STARS) $(SBUCKS) $(STOV) $(TEXV) $(TEXB2B) $(TEXSB) \
    $(TEX4) $(TEXLB) $(SKEW) $(SGEN) $(SU) $(SF) $(MOVE) $(SKA) $(SKABS) \
    $(USKA) $(TEXT) $(DFCB)

all: $(ALL:%=%.opt) lib

common.cmx: binary_graph.cmx h.cmx utils.cmx t.cmx
load_graph.ml tokyo_graph.ml json_graph.ml: common.ml
skew_c.cmx: kendall_c.cmx skew.cmx
skew_c.cmo: kendall_c.cmo skew.cmo

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

#lib.cma lib.cmxa: lib
#lib: kendall_tau.o kendall/tau.o \
#     h.cmo graph.cmo utils.cmo binary_graph.cmo t.cmo common.cmo const.cmo by_day.cmo dranges.cmo dreps.cmo proportional.cmo dcaps.cmo kendall.cmo skew.cmo mathy.cmo soc_run_common.cmo \
#     h.cmx graph.cmx utils.cmx binary_graph.cmx t.cmx common.cmx const.cmx by_day.cmx dranges.cmx dreps.cmx proportional.cmx dcaps.cmx kendall.cmx skew.cmx mathy.cmx soc_run_common.cmx \
#	ocamlmklib -o lib $^

lib: lib.cma
lib.cma:  h.cmo graph.cmo utils.cmo binary_graph.cmo t.cmo common.cmo const.cmo by_day.cmo dranges.cmo dreps.cmo proportional.cmo dcaps.cmo kendall.cmo skew.cmo mathy.cmo soc_run_common.cmo
	ocamlfind ocamlc -a -o $@ $^
lib.cmxa: h.cmx graph.cmx utils.cmx binary_graph.cmx t.cmx common.cmx const.cmx by_day.cmx dranges.cmx dreps.cmx proportional.cmx dcaps.cmx kendall.cmx skew.cmx mathy.cmx soc_run_common.cmx
	ocamlfind ocamlopt -a -o $@ $^

#anygraph.cma anygraph.cmxa: anygraph
#anygraph:  json_graph.cmo tokyo_graph.cmo load_graph.cmo \
#           json_graph.cmx tokyo_graph.cmx load_graph.cmx
#	ocamlmklib -o anygraph $^

anygraph.cma:  json_graph.cmo tokyo_graph.cmo load_graph.cmo
	ocamlfind ocamlc -a -o $@ $^
anygraph.cmxa: json_graph.cmx tokyo_graph.cmx load_graph.cmx
	ocamlfind ocamlopt -a -o $@ $^


#sgraph.cma sgraph.cmxa: sgraph
#sgraph: soc_run_common.cmo ustats.cmo sgraph.cmo \
#        soc_run_common.cmx ustats.cmx sgraph.cmx
#	ocamlmklib -o sgraph $^

sgraph.cma:  soc_run_common.cmo ustats.cmo sgraph.cmo
	ocamlfind ocamlc -a -o $@ $^
sgraph.cmxa: soc_run_common.cmx ustats.cmx sgraph.cmx
	ocamlfind ocamlopt -a -o $@ $^

clean:
	rm -f *.cmi *.cmo *.cmx *.o *.opt *.cma *.cmxa


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

$(SIM1).opt: lib.cmxa invert.cmx simulate.cmx $(SIM1).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SIM1).byte: lib.cma invert.cmo simulate.cmo $(SIM1).cmo
	ocamlfind ocamlc $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

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

$(SKEW).opt: lib.cmxa anygraph.cmxa sgraph.cmxa invert.cmx suds.cmx socday.cmx soc_run_skew.cmx $(SKEW).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(SKEW).byte: lib.cma anygraph.cma sgraph.cma  invert.cmo suds.cmo socday.cmo soc_run_skew.cmo $(SKEW).ml
	ocamlfind ocamlc $(DEBUG) -package $(PACKAGES) -linkpkg $^ -o $@

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

$(B2B).opt: lib.cmxa invert.cmx bucket_power.cmx $(B2B).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(OPT).opt: $(OPT).cmx
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(STARS).opt: lib.cmxa invert.cmx starrank.cmx $(STARS).ml
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

$(SF).opt: lib.cmxa invert.cmx topsets.cmx cranks.cmx sgraph.cmxa suds_local.cmx socday.cmx attachment_fof.cmx simulate_utility_fof.cmx soc_run_fof.cmx $(SF).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@

$(MOVE).opt: lib.cmxa bucket_power.cmx $(MOVE).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -o $@
	
$(SKA).opt: kendall.a lib.cmxa kendall_c.cmxa skew_c.cmx skew_c.cmx $(SKA).ml
	ocamlfind ocamlopt -verbose $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -ccopt '-L.' -o $@
	
$(SKABS).opt: kendall.a lib.cmxa kendall_c.cmxa skew_c.cmx skew_c.cmx $(SKABS).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -ccopt '-L.' -o $@

$(USKA).opt: kendall.a lib.cmxa kendall_c.cmxa skew_c.cmx skew_c.cmx $(USKA).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -package $(PACKAGES) -linkpkg $^ -ccopt '-L.' -o $@

kendall_c.cmxa kendall_c.cma: kendall_c.cmx kendall_c.cmo $(KENDALL_C_OBJ)
	ocamlmklib -o kendall_c $^

$(KENDALL_C_OBJ): %.o: %.c
	$(CC) -O3 -c -I`ocamlc -where` -m64 -fPIC $^ -o $@

kendall.a: $(KENDALL_C_OBJ)
	ar rc $@ $^
	ranlib $@

clean-c:
	rm -f $(KENDALL_C_OBJ)
	
$(TEXT).opt: lib.cmxa teX.cmx $(TEXT).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -syntax camlp4o -package $(PACKAGES) -linkpkg $^ -o $@

$(DFCB).opt: lib.cmxa teX.cmx $(DFCB).ml
	ocamlfind ocamlopt $(DEBUG) $(OPTFLAGS) -syntax camlp4o -package $(PACKAGES) -linkpkg $^ -o $@

$(DFCB).byte: lib.cma teX.cmo $(DFCB).ml
	ocamlfind ocamlc $(DEBUG) $(OPTFLAGS) -syntax camlp4o -package $(PACKAGES) -o $@
