TEX_DIR=tex
include $(MK_DIR)/dir.mk

AVG1_LIST_TEX=$(LINE1_LIST:%.mlb=$(TEX_DIR)/averages-%.tex)
AVG2_LIST_TEX=$(LINE2_LIST:%.mlb=$(TEX_DIR)/averages-%.tex)

MED1_LIST_TEX=$(AVG1_LIST_TEX:$(TEX_DIR)/averages-%=$(TEX_DIR)/medians-%)
MED2_LIST_TEX=$(AVG2_LIST_TEX:$(TEX_DIR)/averages-%=$(TEX_DIR)/medians-%)

AVG1_TEX=$(SUMMARY_PREFIX1:%=$(TEX_DIR)/%-averages.tex)
AVG2_TEX=$(SUMMARY_PREFIX2:%=$(TEX_DIR)/%-averages.tex)

MED1_TEX=$(SUMMARY_PREFIX1:%=$(TEX_DIR)/%-medians.tex)
MED2_TEX=$(SUMMARY_PREFIX2:%=$(TEX_DIR)/%-medians.tex)

RAW_TEX=$(AVG1_TEX) $(MED1_TEX) $(AVG2_TEX) $(MED2_TEX)

N_AVG1_TEX=$(AVG1_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
N_AVG2_TEX=$(AVG2_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
N_MED1_TEX=$(MED1_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
N_MED2_TEX=$(MED2_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
  
NUMBERED=$(N_AVG1_TEX) $(N_MED1_TEX) $(N_AVG2_TEX) $(N_MED2_TEX)

# overx-
CUTPOS   ?= 1
CUT=cut -c $(CUTPOS)-
ROWNUMBER=../../../tex/rownumber.opt
HLINE1   ?= -h4
HLINE2   ?= -h3

.PHONY: sum-tex show-sum-tex clean-sum-tex
  
sum-tex: $(NUMBERED)
  
show-sum-tex:
	@echo AVG1_LIST_TEX: $(AVG1_LIST_TEX)
	@echo MED1_LIST_TEX: $(MED1_LIST_TEX)
	@echo AVG2_LIST_TEX: $(AVG2_LIST_TEX)
	@echo MED2_LIST_TEX: $(MED2_LIST_TEX)

$(AVG1_TEX): $(AVG1_LIST_TEX)
	cat $^ | $(CUT) > $@

$(AVG2_TEX): $(AVG2_LIST_TEX)
	cat $^ | $(CUT) > $@

$(MED1_TEX): $(MED1_LIST_TEX)
	cat $^ | $(CUT) > $@

$(MED2_TEX): $(MED2_LIST_TEX)
	cat $^ | $(CUT) > $@

$(N_AVG1_TEX) $(N_MED1_TEX): $(TEX_DIR)/n-%: $(TEX_DIR)/%
	$(ROWNUMBER) $(HLINE1) < $^ > $@

$(N_AVG2_TEX) $(N_MED2_TEX): $(TEX_DIR)/n-%: $(TEX_DIR)/%
	for i in `wc -l $(AVG1_TEX) | cut -c -8`; do $(ROWNUMBER) -i -n$$i $(HLINE2) < $^ > $@; done

clean-sum-tex:
	rm -f $(RAW_TEX) $(NUMBERED)