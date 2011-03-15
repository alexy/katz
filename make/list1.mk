BASES             ?= $(BASE)

BASE_LIST=$(foreach base,$(BASES),$(shell cat $(LS_DIR)/$(base).list))

LIST=\
$(if $(FROM_QUAD_SUFFIX),\
	$(foreach base,$(BASE_LIST),\
		$(if $(findstring $(FROM_QUAD_SUFFIX),$(base)),\
			$(QUAD_PREFIX)$(base:%$(FROM_QUAD_SUFFIX)=%$(QUAD_SUFFIX)),\
			$(TABLE_PREFIX)$(base).mlb)),\
  $(BASE2_LIST:%=$(TABLE_PREFIX)%.mlb))


MLB_LIST  =$(filter %.mlb, $(LIST))
LINE_LIST =$(if $(DROP),$(subst $(DROP),,$(MLB_LIST)),$(MLB_LIST))
DIR_LIST  =$(filter-out %.mlb,$(LIST))