LINE_AVG_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(AVG)-$(DREPS)-%.tex)
LINE_MED_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(MED)-$(DREPS)-%.tex)

DIR_AVG_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(AVG).tex)
DIR_MED_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(MED).tex)

$(DIR_AVG_TEX): $(LINE_AVG_LIST)
	cat $^ > $@

$(DIR_MED_TEX): $(LINE_MED_LIST)
	cat $^ > $@

DIR_TEX = $(DIR_AVG_TEX) $(DIR_MED_TEX)
dir-tex: $(DIR_TEX)

clean-dir-tex: 
	rm -f $(DIR_TEX)

