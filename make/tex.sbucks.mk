TEX_DIR=tex
#include $(MK_DIR)/dir.sbucks.mk

AVG_LIST_AVG_SELF_TEX=$(LIST_AVG_SELF:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_AVG_STAR_TEX=$(LIST_AVG_STAR:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_AVG_AUDS_TEX=$(LIST_AVG_AUDS:%=$(TEX_DIR)/averages-%.tex)
MED_LIST_AVG_SELF_TEX=$(LIST_AVG_SELF:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_AVG_STAR_TEX=$(LIST_AVG_STAR:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_AVG_AUDS_TEX=$(LIST_AVG_AUDS:%=$(TEX_DIR)/medians-%.tex)

AVG_LIST_MED_SELF_TEX=$(LIST_MED_SELF:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_MED_STAR_TEX=$(LIST_MED_STAR:%=$(TEX_DIR)/averages-%.tex)
AVG_LIST_MED_AUDS_TEX=$(LIST_MED_AUDS:%=$(TEX_DIR)/averages-%.tex)
MED_LIST_MED_SELF_TEX=$(LIST_MED_SELF:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_MED_STAR_TEX=$(LIST_MED_STAR:%=$(TEX_DIR)/medians-%.tex)
MED_LIST_MED_AUDS_TEX=$(LIST_MED_AUDS:%=$(TEX_DIR)/medians-%.tex)


AVG_AVG_SELF_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(SELF)-$(AVG)-averages.tex)
AVG_AVG_STAR_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(STAR)-$(AVG)-averages.tex)
AVG_AVG_AUDS_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(AUDS)-$(AVG)-averages.tex)
MED_AVG_SELF_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(SELF)-$(AVG)-medians.tex)
MED_AVG_STAR_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(STAR)-$(AVG)-medians.tex)
MED_AVG_AUDS_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(AUDS)-$(AVG)-medians.tex)

AVG_MED_SELF_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(SELF)-$(MED)-averages.tex)
AVG_MED_STAR_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(STAR)-$(MED)-averages.tex)
AVG_MED_AUDS_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(AUDS)-$(MED)-averages.tex)
MED_MED_SELF_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(SELF)-$(MED)-medians.tex)
MED_MED_STAR_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(STAR)-$(MED)-medians.tex)
MED_MED_AUDS_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/%-$(AUDS)-$(MED)-medians.tex)

AVG_AVG_TEX=$(AVG_AVG_SELF_TEX) $(AVG_AVG_STAR_TEX) $(AVG_AVG_AUDS_TEX)
MED_AVG_TEX=$(MED_AVG_SELF_TEX) $(MED_AVG_STAR_TEX) $(MED_AVG_AUDS_TEX)
AVG_MED_TEX=$(AVG_MED_SELF_TEX) $(AVG_MED_STAR_TEX) $(AVG_MED_AUDS_TEX)
MED_MED_TEX=$(MED_MED_SELF_TEX) $(MED_MED_STAR_TEX) $(MED_MED_AUDS_TEX)
        
RAW_TEX=$(AVG_AVG_TEX) $(MED_AVG_TEX) $(AVG_MED_TEX) $(MED_MED_TEX)

NUMBERED=$(RAW_TEX:$(TEX_DIR)/%=$(TEX_DIR)/n-%)
  
CUTPOS ?= 1
CUT=cut -c $(CUTPOS)-

.PHONY: sum-tex show-sum-tex clean-sum-tex
  
sum-tex: $(NUMBERED)
  
$(AVG_AVG_SELF_TEX): $(AVG_LIST_AVG_SELF_TEX)
	cat $^ | $(CUT) > $@

$(AVG_AVG_STAR_TEX): $(AVG_LIST_AVG_STAR_TEX)
	cat $^ | $(CUT) > $@

$(AVG_AVG_AUDS_TEX): $(AVG_LIST_AVG_AUDS_TEX)
	cat $^ | $(CUT) > $@

$(MED_AVG_SELF_TEX): $(MED_LIST_AVG_SELF_TEX)
	cat $^ | $(CUT) > $@

$(MED_AVG_STAR_TEX): $(MED_LIST_AVG_STAR_TEX)
	cat $^ | $(CUT) > $@

$(MED_AVG_AUDS_TEX): $(MED_LIST_AVG_AUDS_TEX)
	cat $^ | $(CUT) > $@

$(AVG_MED_SELF_TEX): $(AVG_LIST_MED_SELF_TEX)
	cat $^ | $(CUT) > $@

$(AVG_MED_STAR_TEX): $(AVG_LIST_MED_STAR_TEX)
	cat $^ | $(CUT) > $@

$(AVG_MED_AUDS_TEX): $(AVG_LIST_MED_AUDS_TEX)
	cat $^ | $(CUT) > $@

$(MED_MED_SELF_TEX): $(MED_LIST_MED_SELF_TEX)
	cat $^ | $(CUT) > $@

$(MED_MED_STAR_TEX): $(MED_LIST_MED_STAR_TEX)
	cat $^ | $(CUT) > $@

$(MED_MED_AUDS_TEX): $(MED_LIST_MED_AUDS_TEX)
	cat $^ | $(CUT) > $@


$(NUMBERED): $(TEX_DIR)/n-%: $(TEX_DIR)/%
	$(ROWNUMBER) $(HLINE) < $^ > $@

clean-sum-tex:
	rm -f $(RAW_TEX) $(NUMBERED)