FROM_TABLE_PREFIX ?= prefix-
FROM_QUAD_PREFIX  ?= quad-prefix-
FROM_QUAD_SUFFIX  ?= -suffix

BASE_LIST=$(foreach base,$(BASE),$(shell cat $(LS_DIR)/$(base).list))
PRET_LIST=$(if $(TABLE_PREFIX),$(BASE_LIST:$(FROM_TABLE_PREFIX)%=$(TABLE_PREFIX)%),$(BASE_LIST))
PRE_LIST =$(if $(QUAD_PREFIX), $(PRET_LIST:$(FROM_QUAD_PREFIX)%= $(QUAD_PREFIX)%), $(PRET_LIST))

MLB_LIST =$(filter %.mlb, $(PRE_LIST))
LINE_LIST=$(if $(DROP),$(subst $(DROP),,$(MLB_LIST)),$(MLB_LIST))

LIST     =$(PRE_LIST:%$(FROM_QUAD_SUFFIX)=%$(QUAD_SUFFIX))
