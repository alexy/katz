BASE1_LIST=$(shell cat $(LS_DIR)/$(BASE1).list)
BASE2_LIST=$(shell cat $(LS_DIR)/$(BASE2).list)

LIST1=\
$(if $(FROM_QUAD_SUFFIX),\
	$(foreach base,$(BASE1_LIST),\
		$(if $(findstring $(FROM_QUAD_SUFFIX),$(base)),\
			$(QUAD_PREFIX)$(base:%$(FROM_QUAD_SUFFIX)=%$(QUAD_SUFFIX)),\
			$(TABLE_PREFIX)$(base).mlb)),\
  $(BASE1_LIST:%=$(TABLE_PREFIX)%.mlb))
  
LIST2=\
$(if $(FROM_QUAD_SUFFIX),\
	$(foreach base,$(BASE2_LIST),\
		$(if $(findstring $(FROM_QUAD_SUFFIX),$(base)),\
			$(QUAD_PREFIX)$(base:%$(FROM_QUAD_SUFFIX)=%$(QUAD_SUFFIX)),\
			$(TABLE_PREFIX)$(base).mlb)),\
  $(BASE2_LIST:%=$(TABLE_PREFIX)%.mlb))

MLB1_LIST =$(filter %.mlb, $(LIST1))
MLB2_LIST =$(filter %.mlb, $(LIST2))

LINE1_LIST=$(if $(DROP),$(subst $(DROP),,$(MLB1_LIST)),$(MLB1_LIST))
LINE2_LIST=$(if $(DROP),$(subst $(DROP),,$(MLB2_LIST)),$(MLB2_LIST))
LINE_LIST =$(LINE1_LIST) $(LINE2_LIST)

LIST      =$(LIST1) $(LIST2) 
DIR_LIST  =$(filter-out %.mlb,$(LIST))

list:
	@echo FROM_QUAD_SUFFIX: $(FROM_QUAD_SUFFIX)
	@echo LIST1: $(LIST1)
	@echo LIST2: $(LIST2)