include $(MK_DIR)/list1.mk
TXT_DIR=txt

AVG_LIST_TXT=$(LINE_LIST:%.mlb=$(TXT_DIR)/averages-%.txt)
MED_LIST_TXT=$(AVG_LIST_TXT:$(TXT_DIR)/averages-%=$(TXT_DIR)/medians-%)

AVG_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-averages.txt)
MED_TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%-medians.txt)

TXT=$(AVG_TXT) $(MED_TXT)

# overx-
CUTPOS   ?= 1
CUT=cut -c $(CUTPOS)-

.PHONY: sum-txt show-sum-txt clean-sum-txt
  
sum-txt: $(TXT)
  
show-sum-txt:
	@echo AVG_LIST_TXT: $(AVG_LIST_TXT)
	@echo MED_LIST_TXT: $(MED_LIST_TXT)

$(AVG_TXT): $(AVG_LIST_TXT)
	cat $^ | $(CUT) > $@

$(MED_TXT): $(MED_LIST_TXT)
	cat $^ | $(CUT) > $@

clean-sum-txt:
	rm -f $(TXT)