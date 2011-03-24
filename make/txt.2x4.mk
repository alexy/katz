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


AVG_R1_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R1)-averages.txt)
AVG_R1_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R1)-averages.txt)
AVG_R1_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R1)-averages.txt)
MED_R1_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R1)-medians.txt)
MED_R1_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R1)-medians.txt)
MED_R1_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R1)-medians.txt)

AVG_R2_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R2)-averages.txt)
AVG_R2_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R2)-averages.txt)
AVG_R2_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R2)-averages.txt)
MED_R2_K1_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K1)-$(R2)-medians.txt)
MED_R2_K2_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K2)-$(R2)-medians.txt)
MED_R2_K3_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K3)-$(R2)-medians.txt)

ifdef $(K4)
AVG_R1_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R1)-averages.txt)
MED_R1_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R1)-medians.txt)
AVG_R2_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R2)-averages.txt)
MED_R2_K4_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(K4)-$(R2)-medians.txt)
endif

AVG_R1_TXT=$(AVG_R1_K1_TXT) $(AVG_R1_K2_TXT) $(AVG_R1_K3_TXT) $(AVG_R1_K4_TXT)
MED_R1_TXT=$(MED_R1_K1_TXT) $(MED_R1_K2_TXT) $(MED_R1_K3_TXT) $(MED_R1_K4_TXT)
AVG_R2_TXT=$(AVG_R2_K1_TXT) $(AVG_R2_K2_TXT) $(AVG_R2_K3_TXT) $(AVG_R2_K4_TXT)
MED_R2_TXT=$(MED_R2_K1_TXT) $(MED_R2_K2_TXT) $(MED_R2_K3_TXT) $(MED_R2_K4_TXT)
        
TXT=$(AVG_R1_TXT) $(MED_R1_TXT) $(AVG_R2_TXT) $(MED_R2_TXT)
  
CUTPOS    ?= 1
CUTPOS_R1 ?= $(CUTPOS)
CUTPOS_R2 ?= $(CUTPOS)

CUT_R1=cut -c $(CUTPOS_R1)-
CUT_R2=cut -c $(CUTPOS_R2)-

.PHONY: sum-txt show-sum-txt clean-sum-txt
  
sum-txt: $(TXT)
  
$(AVG_R1_K1_TXT): $(AVG_LIST_R1_K1_TXT)
	cat $^ | $(CUT_R1) > $@

$(AVG_R1_K2_TXT): $(AVG_LIST_R1_K2_TXT)
	cat $^ | $(CUT_R1) > $@

$(AVG_R1_K3_TXT): $(AVG_LIST_R1_K3_TXT)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K1_TXT): $(MED_LIST_R1_K1_TXT)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K2_TXT): $(MED_LIST_R1_K2_TXT)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K3_TXT): $(MED_LIST_R1_K3_TXT)
	cat $^ | $(CUT_R1) > $@

$(AVG_R2_K1_TXT): $(AVG_LIST_R2_K1_TXT)
	cat $^ | $(CUT_R2) > $@

$(AVG_R2_K2_TXT): $(AVG_LIST_R2_K2_TXT)
	cat $^ | $(CUT_R2) > $@

$(AVG_R2_K3_TXT): $(AVG_LIST_R2_K3_TXT)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K1_TXT): $(MED_LIST_R2_K1_TXT)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K2_TXT): $(MED_LIST_R2_K2_TXT)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K3_TXT): $(MED_LIST_R2_K3_TXT)
	cat $^ | $(CUT_R2) > $@

ifdef $(K4)
$(AVG_R1_K4_TXT): $(AVG_LIST_R1_K4_TXT)
	cat $^ | $(CUT_R1) > $@

$(MED_R1_K4_TXT): $(MED_LIST_R1_K4_TXT)
	cat $^ | $(CUT_R1) > $@

$(AVG_R2_K4_TXT): $(AVG_LIST_R2_K4_TXT)
	cat $^ | $(CUT_R2) > $@

$(MED_R2_K4_TXT): $(MED_LIST_R2_K4_TXT)
	cat $^ | $(CUT_R2) > $@
endif

clean-sum-txt:
	rm -f $(TXT)