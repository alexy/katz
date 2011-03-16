TXT_DIR=txt
#include $(MK_DIR)/dir.sbucks.mk

AVG_LIST_AVG_SELF_TXT=$(LIST_AVG_SELF:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_AVG_STAR_TXT=$(LIST_AVG_STAR:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_AVG_AUDS_TXT=$(LIST_AVG_AUDS:%=$(TXT_DIR)/averages-%.txt)
MED_LIST_AVG_SELF_TXT=$(LIST_AVG_SELF:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_AVG_STAR_TXT=$(LIST_AVG_STAR:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_AVG_AUDS_TXT=$(LIST_AVG_AUDS:%=$(TXT_DIR)/medians-%.txt)

AVG_LIST_MED_SELF_TXT=$(LIST_MED_SELF:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_MED_STAR_TXT=$(LIST_MED_STAR:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_MED_AUDS_TXT=$(LIST_MED_AUDS:%=$(TXT_DIR)/averages-%.txt)
MED_LIST_MED_SELF_TXT=$(LIST_MED_SELF:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_MED_STAR_TXT=$(LIST_MED_STAR:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_MED_AUDS_TXT=$(LIST_MED_AUDS:%=$(TXT_DIR)/medians-%.txt)


AVG_AVG_SELF_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(SELF)-$(AVG)-averages.txt)
AVG_AVG_STAR_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(STAR)-$(AVG)-averages.txt)
AVG_AVG_AUDS_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(AUDS)-$(AVG)-averages.txt)
MED_AVG_SELF_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(SELF)-$(AVG)-medians.txt)
MED_AVG_STAR_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(STAR)-$(AVG)-medians.txt)
MED_AVG_AUDS_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(AUDS)-$(AVG)-medians.txt)

AVG_MED_SELF_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(SELF)-$(MED)-averages.txt)
AVG_MED_STAR_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(STAR)-$(MED)-averages.txt)
AVG_MED_AUDS_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(AUDS)-$(MED)-averages.txt)
MED_MED_SELF_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(SELF)-$(MED)-medians.txt)
MED_MED_STAR_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(STAR)-$(MED)-medians.txt)
MED_MED_AUDS_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(AUDS)-$(MED)-medians.txt)

AVG_AVG_TXT=$(AVG_AVG_SELF_TXT) $(AVG_AVG_STAR_TXT) $(AVG_AVG_AUDS_TXT)
MED_AVG_TXT=$(MED_AVG_SELF_TXT) $(MED_AVG_STAR_TXT) $(MED_AVG_AUDS_TXT)
AVG_MED_TXT=$(AVG_MED_SELF_TXT) $(AVG_MED_STAR_TXT) $(AVG_MED_AUDS_TXT)
MED_MED_TXT=$(MED_MED_SELF_TXT) $(MED_MED_STAR_TXT) $(MED_MED_AUDS_TXT)
        
TXT=$(AVG_AVG_TXT) $(MED_AVG_TXT) $(AVG_MED_TXT) $(MED_MED_TXT)
  
CUTPOS ?= 1
CUT=cut -c $(CUTPOS)-

.PHONY: sum-txt show-sum-txt clean-sum-txt
  
sum-txt: $(TXT)
  

$(AVG_AVG_SELF_TXT): $(AVG_LIST_AVG_SELF_TXT)
	cat $^ | $(CUT) > $@

$(AVG_AVG_STAR_TXT): $(AVG_LIST_AVG_STAR_TXT)
	cat $^ | $(CUT) > $@

$(AVG_AVG_AUDS_TXT): $(AVG_LIST_AVG_AUDS_TXT)
	cat $^ | $(CUT) > $@

$(MED_AVG_SELF_TXT): $(MED_LIST_AVG_SELF_TXT)
	cat $^ | $(CUT) > $@

$(MED_AVG_STAR_TXT): $(MED_LIST_AVG_STAR_TXT)
	cat $^ | $(CUT) > $@

$(MED_AVG_AUDS_TXT): $(MED_LIST_AVG_AUDS_TXT)
	cat $^ | $(CUT) > $@

$(AVG_MED_SELF_TXT): $(AVG_LIST_MED_SELF_TXT)
	cat $^ | $(CUT) > $@

$(AVG_MED_STAR_TXT): $(AVG_LIST_MED_STAR_TXT)
	cat $^ | $(CUT) > $@

$(AVG_MED_AUDS_TXT): $(AVG_LIST_MED_AUDS_TXT)
	cat $^ | $(CUT) > $@

$(MED_MED_SELF_TXT): $(MED_LIST_MED_SELF_TXT)
	cat $^ | $(CUT) > $@

$(MED_MED_STAR_TXT): $(MED_LIST_MED_STAR_TXT)
	cat $^ | $(CUT) > $@

$(MED_MED_AUDS_TXT): $(MED_LIST_MED_AUDS_TXT)
	cat $^ | $(CUT) > $@


clean-sum-txt:
	rm -f $(TXT)