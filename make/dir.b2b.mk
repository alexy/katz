LINE_ABS_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(ABS)-$(WHATS_UP)-%.tex)
LINE_REL_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(REL)-$(WHATS_UP)-%.tex)

DIR_ABS_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(ABS).tex)
DIR_REL_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(REL).tex)

$(DIR_ABS_TEX): $(LINE_ABS_LIST)
	cat $^ > $@

$(DIR_REL_TEX): $(LINE_REL_LIST)
	cat $^ > $@

DIR_TEX = $(DIR_ABS_TEX) $(DIR_REL_TEX)
dir-tex: $(DIR_TEX)

clean-dir-tex: 
	rm -f $(DIR_TEX)

