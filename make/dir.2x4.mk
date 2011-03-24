LINE_R1_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(R1)-$(WHATS_UP)-%.tex)
LINE_R2_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(R2)-$(WHATS_UP)-%.tex)

DIR_R1_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(R1).tex)
DIR_R2_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%-$(R2).tex)

$(DIR_R1_TEX): $(LINE_R1_LIST)
	cat $^ > $@

$(DIR_R2_TEX): $(LINE_R2_LIST)
	cat $^ > $@

DIR_TEX = $(DIR_R1_TEX) $(DIR_R2_TEX)
dir-tex: $(DIR_TEX)

clean-dir-tex: 
	rm -f $(DIR_TEX)

