BASES ?= $(BASE)

FROM_QUAD_PREFIX  ?= quad-
FROM_QUAD_SUFFIX  ?= -suffix

BASE_LIST=$(foreach base,$(BASES),$(shell cat $(LS_DIR)/$(base).list))

PRE_LIST=\
$(if $(FROM_QUAD_SUFFIX),\
	$(foreach base,$(BASE_LIST),\
		$(if $(findstring $(FROM_QUAD_SUFFIX),$(base)),\
			$(QUAD_PREFIX)$(base:%$(FROM_QUAD_SUFFIX)=%$(QUAD_SUFFIX)),\
			$(TABLE_PREFIX)$(base).mlb)),\
  $(BASE2_LIST:%=$(TABLE_PREFIX)%.mlb))


MLB_LIST  =$(filter %.mlb, $(PRE_LIST))

LINE_LIST =$(if $(DROP),$(subst $(DROP),,$(MLB_LIST)),$(MLB_LIST))

LIST      =$(PRE_LIST:%$(FROM_QUAD_SUFFIX)=%$(QUAD_SUFFIX))
DIR_LIST  =$(filter-out %.mlb,$(LIST))