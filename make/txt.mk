CUTPOS ?= 7-
CUT=cut -c $(CUTPOS)

BASE_LIST=$(foreach base,$(BASES),$(shell cat ../$(base).list))
MLB_LIST=$(filter %.mlb, $(BASE_LIST))

AVG_LIST=$(MLB_LIST:%.mlb=averages-%.txt)
MED_LIST=$(AVG_LIST:averages-%=medians-%)

AVG_TXT=$(BASES:%=%-averages.txt)
MED_TXT=$(BASES:%=%-medians.txt)

TXT=$(AVG_TXT) $(MED_TXT)

.PHONY: echo
  
all: $(TXT)
  
echo:
	@echo AVG_LIST: $(AVG_LIST)
	@echo MED_LIST: $(MED_LIST)

$(AVG_TXT): $(AVG_LIST)
	cat $^ | $(CUT) > $@

$(MED_TXT): $(MED_LIST)
	cat $^ | $(CUT) > $@

clean:
	rm -f $(TXT)