TXT_DIR=txt

TXT_LIST=$(MLB_LIST:%.mlb=$(TXT_DIR)/%.txt)

TXT=$(SUMMARY_PREFIX:%=$(TXT_DIR)/%.txt)

sum-txt: $(TXT)

$(TXT): $(TXT_LIST)
	cat $^ > $@