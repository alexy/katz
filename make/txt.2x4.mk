TXT_DIR ?= txt.2x4

AVG_LIST_R1_K1_TXT=$(LIST_R1_K1:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_R1_K2_TXT=$(LIST_R1_K2:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_R1_K3_TXT=$(LIST_R1_K3:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_R1_K4_TXT=$(LIST_R1_K4:%=$(TXT_DIR)/averages-%.txt)
MED_LIST_R1_K1_TXT=$(LIST_R1_K1:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_R1_K2_TXT=$(LIST_R1_K2:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_R1_K3_TXT=$(LIST_R1_K3:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_R1_K4_TXT=$(LIST_R1_K4:%=$(TXT_DIR)/medians-%.txt)

AVG_LIST_R2_K1_TXT=$(LIST_R2_K1:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_R2_K2_TXT=$(LIST_R2_K2:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_R2_K3_TXT=$(LIST_R2_K3:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_R2_K4_TXT=$(LIST_R2_K4:%=$(TXT_DIR)/averages-%.txt)
MED_LIST_R2_K1_TXT=$(LIST_R2_K1:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_R2_K2_TXT=$(LIST_R2_K2:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_R2_K3_TXT=$(LIST_R2_K3:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_R2_K4_TXT=$(LIST_R2_K4:%=$(TXT_DIR)/medians-%.txt)

show:
	@echo MED_LIST_R2_K4_TXT: $(MED_LIST_R2_K4_TXT)


AVG_R1_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R1)-averages.txt)
AVG_R1_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R1)-averages.txt)
AVG_R1_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R1)-averages.txt)
AVG_R1_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R1)-averages.txt)
MED_R1_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R1)-medians.txt)
MED_R1_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R1)-medians.txt)
MED_R1_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R1)-medians.txt)
MED_R1_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R1)-medians.txt)

AVG_R2_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R2)-averages.txt)
AVG_R2_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R2)-averages.txt)
AVG_R2_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R2)-averages.txt)
AVG_R2_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R2)-averages.txt)
MED_R2_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R2)-medians.txt)
MED_R2_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R2)-medians.txt)
MED_R2_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R2)-medians.txt)
MED_R2_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R2)-medians.txt)

AVG_R1_TXT=$(AVG_R1_K1_TXT) $(AVG_R1_K2_TXT) $(AVG_R1_K3_TXT) $(AVG_R1_K4_TXT)
MED_R1_TXT=$(MED_R1_K1_TXT) $(MED_R1_K2_TXT) $(MED_R1_K3_TXT) $(MED_R1_K4_TXT)
AVG_R2_TXT=$(AVG_R2_K1_TXT) $(AVG_R2_K2_TXT) $(AVG_R2_K3_TXT) $(AVG_R2_K4_TXT)
MED_R2_TXT=$(MED_R2_K1_TXT) $(MED_R2_K2_TXT) $(MED_R2_K3_TXT) $(MED_R2_K4_TXT)
        
TXT=$(AVG_R1_TXT) $(MED_R1_TXT) $(AVG_R2_TXT) $(MED_R2_TXT)

CUTPOS ?= 1
CUT=cut -c $(CUTPOS)-

.PHONY: sum-txt show-sum-txt clean-sum-txt
  
sum-txt: $(TXT)
  
$(AVG_R1_K1_TXT): $(AVG_LIST_R1_K1_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R1_K2_TXT): $(AVG_LIST_R1_K2_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R1_K3_TXT): $(AVG_LIST_R1_K3_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R1_K4_TXT): $(AVG_LIST_R1_K4_TXT)
	cat $^ | $(CUT) > $@

$(MED_R1_K1_TXT): $(MED_LIST_R1_K1_TXT)
	cat $^ | $(CUT) > $@

$(MED_R1_K2_TXT): $(MED_LIST_R1_K2_TXT)
	cat $^ | $(CUT) > $@

$(MED_R1_K3_TXT): $(MED_LIST_R1_K3_TXT)
	cat $^ | $(CUT) > $@

$(MED_R1_K4_TXT): $(MED_LIST_R1_K4_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R2_K1_TXT): $(AVG_LIST_R2_K1_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R2_K2_TXT): $(AVG_LIST_R2_K2_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R2_K3_TXT): $(AVG_LIST_R2_K3_TXT)
	cat $^ | $(CUT) > $@

$(AVG_R2_K4_TXT): $(AVG_LIST_R2_K4_TXT)
	cat $^ | $(CUT) > $@

$(MED_R2_K1_TXT): $(MED_LIST_R2_K1_TXT)
	cat $^ | $(CUT) > $@

$(MED_R2_K2_TXT): $(MED_LIST_R2_K2_TXT)
	cat $^ | $(CUT) > $@

$(MED_R2_K3_TXT): $(MED_LIST_R2_K3_TXT)
	cat $^ | $(CUT) > $@

$(MED_R2_K4_TXT): $(MED_LIST_R2_K4_TXT)
	cat $^ | $(CUT) > $@

clean-sum-txt:
	rm -f $(TXT)