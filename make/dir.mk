DIR_INFI=$(if $(DIR_DROP),$(subst $(DIR_DROP),,$(DIR_LIST)),$(DIR_LIST))
LINE_LIST_TEX=$(foreach line,$(DIR_INFI),$(wildcard $(TEX_DIR)/line-4x?-$(line).tex))
DIR_TEX=$(SUMMARY_PREFIX:%=$(TEX_DIR)/dir-%.tex)

$(DIR_TEX): $(LINE_LIST_TEX)
	cat $^ > $@

dir-tex: $(DIR_TEX)
