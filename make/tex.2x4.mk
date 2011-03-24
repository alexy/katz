TEX_DIR ?= tex.2x4
#include $(MK_DIR)/dir.b2b.mk

AVG_LIST_R1_K1_TEX=$(LIST_R1_K1:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_R1_K2_TEX=$(LIST_R1_K2:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_R1_K3_TEX=$(LIST_R1_K3:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_R1_K4_TEX=$(LIST_R1_K4:%=$(TEX_DIR)/averages-%.tex)
MED_LIST_R1_K1_TEX=$(LIST_R1_K1:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_R1_K2_TEX=$(LIST_R1_K2:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_R1_K3_TEX=$(LIST_R1_K3:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_R1_K4_TEX=$(LIST_R1_K4:%=$(TEX_DIR)/medians-%.tex)

AVG_LIST_R2_K1_TEX=$(LIST_R2_K1:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_R2_K2_TEX=$(LIST_R2_K2:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_R2_K3_TEX=$(LIST_R2_K3:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_R2_K4_TEX=$(LIST_R2_K4:%=$(TEX_DIR)/averages-%.tex)
MED_LIST_R2_K1_TEX=$(LIST_R2_K1:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_R2_K2_TEX=$(LIST_R2_K2:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_R2_K3_TEX=$(LIST_R2_K3:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_R2_K4_TEX=$(LIST_R2_K4:%=$(TEX_DIR)/medians-%.tex)


AVG_R1_K1_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K1)-$(R1)-averages.tex)
AVG_R1_K2_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K2)-$(R1)-averages.tex)
AVG_R1_K3_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K3)-$(R1)-averages.tex)
MED_R1_K1_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K1)-$(R1)-medians.tex)
MED_R1_K2_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K2)-$(R1)-medians.tex)
MED_R1_K3_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K3)-$(R1)-medians.tex)

AVG_R2_K1_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K1)-$(R2)-averages.tex)
AVG_R2_K2_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K2)-$(R2)-averages.tex)
AVG_R2_K3_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K3)-$(R2)-averages.tex)
MED_R2_K1_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K1)-$(R2)-medians.tex)
MED_R2_K2_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K2)-$(R2)-medians.tex)
MED_R2_K3_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K3)-$(R2)-medians.tex)

ifdef $(K4)
AVG_R1_K4_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K4)-$(R1)-averages.tex)
MED_R1_K4_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K4)-$(R1)-medians.tex)
AVG_R2_K4_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K4)-$(R2)-averages.tex)
MED_R2_K4_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(K4)-$(R2)-medians.tex)
endif

AVG_R1_TEX=$(AVG_R1_K1_TEX) $(AVG_R1_K2_TEX) $(AVG_R1_K3_TEX) $(AVG_R1_K4_TEX)
MED_R1_TEX=$(MED_R1_K1_TEX) $(MED_R1_K2_TEX) $(MED_R1_K3_TEX) $(MED_R1_K4_TEX)
AVG_R2_TEX=$(AVG_R2_K1_TEX) $(AVG_R2_K2_TEX) $(AVG_R2_K3_TEX) $(AVG_R2_K4_TEX)
MED_R2_TEX=$(MED_R2_K1_TEX) $(MED_R2_K2_TEX) $(MED_R2_K3_TEX) $(MED_R2_K4_TEX)
        
RAW_TEX=$(AVG_R1_TEX) $(MED_R1_TEX) $(AVG_R2_TEX) $(MED_R2_TEX)

NUMBERED=$(RAW_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
  
CUTPOS    ?= 1
CUTPOS_R1 ?= $(CUTPOS)
CUTPOS_R2 ?= $(CUTPOS)

CUT_R1=cut -c $(CUTPOS_R1)-
CUT_R2=cut -c $(CUTPOS_R2)-

.PHONY: sum-tex show-sum-tex clean-sum-tex
  
sum-tex: $(NUMBERED)
  
$(AVG_R1_K1_TEX): $(AVG_LIST_R1_K1_TEX)
	cat $^ | $(CUT_R1) > $@

$(AVG_R1_K2_TEX): $(AVG_LIST_R1_K2_TEX)
	cat $^ | $(CUT_R1) > $@

$(AVG_R1_K3_TEX): $(AVG_LIST_R1_K3_TEX)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K1_TEX): $(MED_LIST_R1_K1_TEX)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K2_TEX): $(MED_LIST_R1_K2_TEX)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K3_TEX): $(MED_LIST_R1_K3_TEX)
	cat $^ | $(CUT_R1) > $@

$(AVG_R2_K1_TEX): $(AVG_LIST_R2_K1_TEX)
	cat $^ | $(CUT_R2) > $@

$(AVG_R2_K2_TEX): $(AVG_LIST_R2_K2_TEX)
	cat $^ | $(CUT_R2) > $@

$(AVG_R2_K3_TEX): $(AVG_LIST_R2_K3_TEX)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K1_TEX): $(MED_LIST_R2_K1_TEX)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K2_TEX): $(MED_LIST_R2_K2_TEX)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K3_TEX): $(MED_LIST_R2_K3_TEX)
	cat $^ | $(CUT_R2) > $@

ifdef $(K4)

$(AVG_R1_K4_TEX): $(AVG_LIST_R1_K4_TEX)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K4_TEX): $(MED_LIST_R1_K4_TEX)
	cat $^ | $(CUT_R1) > $@

$(AVG_R2_K4_TEX): $(AVG_LIST_R2_K4_TEX)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K4_TEX): $(MED_LIST_R2_K4_TEX)
	cat $^ | $(CUT_R2) > $@

endif

$(NUMBERED): $(TEX_DIR)/n-%: $(TEX_DIR)/%
	$(ROWNUMBER) $(HLINE) < $^ > $@

clean-sum-tex:
	rm -f $(RAW_TEX) $(NUMBERED)