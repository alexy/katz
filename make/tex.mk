ROWNUMBER=../../../../tex/rownumber.opt
CUT=cut -c 7-

BASE_LIST=$(foreach base,$(BASES),$(shell cat ../$(base).list))
MLB_LIST=$(filter %.mlb, $(BASE_LIST))

AVG_LIST=$(MLB_LIST:%.mlb=averages-%.tex)
MED_LIST=$(AVG_LIST:averages-%=medians-%)

AVG_TEX=$(BASES:%=%-averages.tex)
MED_TEX=$(BASES:%=%-medians.tex)

RAW_TEX=$(AVG_TEX) $(MED_TEX)

N_AVG_TEX=$(AVG_TEX:%=n-%)
N_MED_TEX=$(MED_TEX:%=n-%)
  
NUMBERED=$(N_AVG_TEX) $(N_MED_TEX)

.PHONY: echo
  
all: $(NUMBERED)
  
echo:
	@echo AVG_LIST: $(AVG_LIST)
	@echo MED_LIST: $(MED_LIST)

$(AVG_TEX): $(AVG_LIST)
	cat $^ | $(CUT) > $@

$(MED_TEX): $(MED_LIST)
	cat $^ | $(CUT) > $@

$(N_AVG_TEX) $(N_MED_TEX): n-%: %
	$(ROWNUMBER) $(HLINE) < $^ > $@

clean:
	rm -f $(RAW_TEX) $(NUMBERED)