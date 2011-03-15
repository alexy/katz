LINE_INT_LIST =$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(Z1)-$(WHATS_UP)-%.tex)
LINE_NORM_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(Z2)-$(WHATS_UP)-%.tex)

DIR_INT_TEX =$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(Z1).tex)
DIR_NORM_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(Z2).tex)

$(DIR_INT_TEX):  $(LINE_INT_LIST)
	cat $^ > $@

$(DIR_NORM_TEX): $(LINE_NORM_LIST)
	cat $^ > $@

DIR_TEX = $(DIR_INT_TEX) $(DIR_NORM_TEX)
dir-tex: $(DIR_TEX)

clean-dir-tex: 
	rm -f $(DIR_TEX)

