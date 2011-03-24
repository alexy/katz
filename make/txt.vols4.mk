TXT_DIR=txt

AVG_LIST_REI_TXT=$(LIST_REI:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_RUI_TXT=$(LIST_RUI:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_MEI_TXT=$(LIST_MEI:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_MUI_TXT=$(LIST_MUI:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_REN_TXT=$(LIST_REN:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_RUN_TXT=$(LIST_RUN:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_MEN_TXT=$(LIST_MEN:%=$(TXT_DIR)/averages-%.txt)
AVG_LIST_MUN_TXT=$(LIST_MUN:%=$(TXT_DIR)/averages-%.txt)

MED_LIST_REI_TXT=$(LIST_REI:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_RUI_TXT=$(LIST_RUI:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_MEI_TXT=$(LIST_MEI:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_MUI_TXT=$(LIST_MUI:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_REN_TXT=$(LIST_REN:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_RUN_TXT=$(LIST_RUN:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_MEN_TXT=$(LIST_MEN:%=$(TXT_DIR)/medians-%.txt)
MED_LIST_MUN_TXT=$(LIST_MUN:%=$(TXT_DIR)/medians-%.txt)

AVG_REI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(REI)-averages.txt)
AVG_RUI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(RUI)-averages.txt)
AVG_MEI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MEI)-averages.txt)
AVG_MUI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MUI)-averages.txt)
AVG_REN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(REN)-averages.txt)
AVG_RUN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(RUN)-averages.txt)
AVG_MEN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MEN)-averages.txt)
AVG_MUN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MUN)-averages.txt)

MED_REI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(REI)-medians.txt)
MED_RUI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(RUI)-medians.txt)
MED_MEI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MEI)-medians.txt)
MED_MUI_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MUI)-medians.txt)
MED_REN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(REN)-medians.txt)
MED_RUN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(RUN)-medians.txt)
MED_MEN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MEN)-medians.txt)
MED_MUN_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-$(MUN)-medians.txt)

AVG_TXT=$(AVG_REI_TXT) $(AVG_RUI_TXT) $(AVG_MEI_TXT) $(AVG_MUI_TXT) \
        $(AVG_REN_TXT) $(AVG_RUN_TXT) $(AVG_MEN_TXT) $(AVG_MUN_TXT) 

MED_TXT=$(MED_REI_TXT) $(MED_RUI_TXT) $(MED_MEI_TXT) $(MED_MUI_TXT) \
        $(MED_REN_TXT) $(MED_RUN_TXT) $(MED_MEN_TXT) $(MED_MUN_TXT) 
        
TXT=$(AVG_TXT) $(MED_TXT)

CUTPOS_I = 14
CUTPOS_N = 15
CUT_I=cut -c $(CUTPOS_I)-
CUT_N=cut -c $(CUTPOS_N)-

.PHONY: sum-txt show-sum-txt clean-sum-txt
  
sum-txt: $(TXT)
  
$(AVG_REI_TXT): $(AVG_LIST_REI_TXT)
	cat $^ | $(CUT_I) > $@

$(AVG_RUI_TXT): $(AVG_LIST_RUI_TXT)
	cat $^ | $(CUT_I) > $@

$(AVG_MEI_TXT): $(AVG_LIST_MEI_TXT)
	cat $^ | $(CUT_I) > $@

$(AVG_MUI_TXT): $(AVG_LIST_MUI_TXT)
	cat $^ | $(CUT_I) > $@

$(AVG_REN_TXT): $(AVG_LIST_REN_TXT)
	cat $^ | $(CUT_N) > $@

$(AVG_RUN_TXT): $(AVG_LIST_RUN_TXT)
	cat $^ | $(CUT_N) > $@

$(AVG_MEN_TXT): $(AVG_LIST_MEN_TXT)
	cat $^ | $(CUT_N) > $@

$(AVG_MUN_TXT): $(AVG_LIST_MUN_TXT)
	cat $^ | $(CUT_N) > $@

$(MED_REI_TXT): $(MED_LIST_REI_TXT)
	cat $^ | $(CUT_I) > $@

$(MED_RUI_TXT): $(MED_LIST_RUI_TXT)
	cat $^ | $(CUT_I) > $@

$(MED_MEI_TXT): $(MED_LIST_MEI_TXT)
	cat $^ | $(CUT_I) > $@

$(MED_MUI_TXT): $(MED_LIST_MUI_TXT)
	cat $^ | $(CUT_I) > $@

$(MED_REN_TXT): $(MED_LIST_REN_TXT)
	cat $^ | $(CUT_N) > $@

$(MED_RUN_TXT): $(MED_LIST_RUN_TXT)
	cat $^ | $(CUT_N) > $@

$(MED_MEN_TXT): $(MED_LIST_MEN_TXT)
	cat $^ | $(CUT_N) > $@

$(MED_MUN_TXT): $(MED_LIST_MUN_TXT)
	cat $^ | $(CUT_N) > $@

clean-sum-txt:
	rm -f $(TXT)