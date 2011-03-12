TEX_DIR=tex
include $(MK_DIR)/list1.mk
include $(MK_DIR)/dir.mk

AVG_LIST_TEX=$(LINE_LIST:%.mlb=$(TEX_DIR)/averages-%.tex)
MED_LIST_TEX=$(AVG_LIST_TEX:$(TEX_DIR)/averages-%=$(TEX_DIR)/medians-%)

AVG_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-averages.tex)
MED_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-medians.tex)

RAW_TEX=$(AVG_TEX) $(MED_TEX)

N_AVG_TEX=$(AVG_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
N_MED_TEX=$(MED_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
  
NUMBERED=$(N_AVG_TEX) $(N_MED_TEX)

# overx-
CUTPOS   ?= 1
CUT=cut -c $(CUTPOS)-
ROWNUMBER=../../../tex/rownumber.opt
HLINE    ?= -h4

.PHONY: sum-tex show-sum-tex clean-sum-tex
  
sum-tex: $(NUMBERED)
  
show-sum-tex:
	@echo LIST:         $(LIST)
	@echo DIR_LIST:     $(DIR_LIST)
	@echo DIR_LIST_TEX: $(DIR_LIST_TEX)
	@echo DIR_TEX:      $(DIR_TEX)

$(AVG_TEX): $(AVG_LIST_TEX)
	cat $^ | $(CUT) > $@

$(MED_TEX): $(MED_LIST_TEX)
	cat $^ | $(CUT) > $@

$(N_AVG_TEX) $(N_MED_TEX): $(TEX_DIR)/n-%: $(TEX_DIR)/%
	$(ROWNUMBER) $(HLINE) < $^ > $@

clean-sum-tex:
	rm -f $(RAW_TEX) $(NUMBERED) $(DIR_TEX)