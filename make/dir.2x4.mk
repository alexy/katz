DIR_BASE ?= $(WHATS_UP)

LINE_R1_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(R1)-$(DIR_BASE)-%.tex)
LINE_R2_LIST=$(BASE_LIST:%=$(TEX_DIR)/line-4x4-$(R2)-$(DIR_BASE)-%.tex)

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

