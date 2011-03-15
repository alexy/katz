TEX_DIR=tex
#include $(MK_DIR)/dir.vols4.mk

AVG_LIST_REI_TEX=$(LIST_REI:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_RUI_TEX=$(LIST_RUI:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_MEI_TEX=$(LIST_MEI:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_MUI_TEX=$(LIST_MUI:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_REN_TEX=$(LIST_REN:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_RUN_TEX=$(LIST_RUN:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_MEN_TEX=$(LIST_MEN:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_MUN_TEX=$(LIST_MUN:%=$(TEX_DIR)/averages-%.tex)

MED_LIST_REI_TEX=$(LIST_REI:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_RUI_TEX=$(LIST_RUI:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_MEI_TEX=$(LIST_MEI:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_MUI_TEX=$(LIST_MUI:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_REN_TEX=$(LIST_REN:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_RUN_TEX=$(LIST_RUN:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_MEN_TEX=$(LIST_MEN:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_MUN_TEX=$(LIST_MUN:%=$(TEX_DIR)/medians-%.tex)

AVG_REI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(REI)-averages.tex)
AVG_RUI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(RUI)-averages.tex)
AVG_MEI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MEI)-averages.tex)
AVG_MUI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MUI)-averages.tex)
AVG_REN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(REN)-averages.tex)
AVG_RUN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(RUN)-averages.tex)
AVG_MEN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MEN)-averages.tex)
AVG_MUN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MUN)-averages.tex)

MED_REI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(REI)-medians.tex)
MED_RUI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(RUI)-medians.tex)
MED_MEI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MEI)-medians.tex)
MED_MUI_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MUI)-medians.tex)
MED_REN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(REN)-medians.tex)
MED_RUN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(RUN)-medians.tex)
MED_MEN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MEN)-medians.tex)
MED_MUN_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(MUN)-medians.tex)

AVG_TEX=$(AVG_REI_TEX) $(AVG_RUI_TEX) $(AVG_MEI_TEX) $(AVG_MUI_TEX) \
        $(AVG_REN_TEX) $(AVG_RUN_TEX) $(AVG_MEN_TEX) $(AVG_MUN_TEX) 

MED_TEX=$(MED_REI_TEX) $(MED_RUI_TEX) $(MED_MEI_TEX) $(MED_MUI_TEX) \
        $(MED_REN_TEX) $(MED_RUN_TEX) $(MED_MEN_TEX) $(MED_MUN_TEX) 
        
RAW_TEX=$(AVG_TEX) $(MED_TEX)

N_AVG_TEX=$(AVG_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
N_MED_TEX=$(MED_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
  
NUMBERED=$(N_AVG_TEX) $(N_MED_TEX)

# overx-
CUTPOS_I = 14
CUTPOS_N = 15
CUT_I=cut -c $(CUTPOS_I)-
CUT_N=cut -c $(CUTPOS_N)-

HLINE ?= -h5

.PHONY: sum-tex show-sum-tex clean-sum-tex
  
sum-tex: $(NUMBERED)
  
$(AVG_REI_TEX): $(AVG_LIST_REI_TEX)
	cat $^ | $(CUT_I) > $@

$(AVG_RUI_TEX): $(AVG_LIST_RUI_TEX)
	cat $^ | $(CUT_I) > $@

$(AVG_MEI_TEX): $(AVG_LIST_MEI_TEX)
	cat $^ | $(CUT_I) > $@

$(AVG_MUI_TEX): $(AVG_LIST_MUI_TEX)
	cat $^ | $(CUT_I) > $@

$(AVG_REN_TEX): $(AVG_LIST_REN_TEX)
	cat $^ | $(CUT_N) > $@

$(AVG_RUN_TEX): $(AVG_LIST_RUN_TEX)
	cat $^ | $(CUT_N) > $@

$(AVG_MEN_TEX): $(AVG_LIST_MEN_TEX)
	cat $^ | $(CUT_N) > $@

$(AVG_MUN_TEX): $(AVG_LIST_MUN_TEX)
	cat $^ | $(CUT_N) > $@

$(MED_REI_TEX): $(MED_LIST_REI_TEX)
	cat $^ | $(CUT_I) > $@

$(MED_RUI_TEX): $(MED_LIST_RUI_TEX)
	cat $^ | $(CUT_I) > $@

$(MED_MEI_TEX): $(MED_LIST_MEI_TEX)
	cat $^ | $(CUT_I) > $@

$(MED_MUI_TEX): $(MED_LIST_MUI_TEX)
	cat $^ | $(CUT_I) > $@

$(MED_REN_TEX): $(MED_LIST_REN_TEX)
	cat $^ | $(CUT_N) > $@

$(MED_RUN_TEX): $(MED_LIST_RUN_TEX)
	cat $^ | $(CUT_N) > $@

$(MED_MEN_TEX): $(MED_LIST_MEN_TEX)
	cat $^ | $(CUT_N) > $@

$(MED_MUN_TEX): $(MED_LIST_MUN_TEX)
	cat $^ | $(CUT_N) > $@


$(N_AVG_TEX) $(N_MED_TEX): $(TEX_DIR)/n-%: $(TEX_DIR)/%
	$(ROWNUMBER) $(HLINE) < $^ > $@

clean-sum-tex:
	rm -f $(RAW_TEX) $(NUMBERED)