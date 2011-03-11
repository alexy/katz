include $(MK_DIR)/list1.mk
include $(MK_DIR)/tex-defs.mk

XARGS_N ?= 5

.PHONY: tex txt
tex:
	mkdir -p tex
	echo $(LIST) | xargs -n$(XARGS_N) $(TEX4RATES) -t -i $(INPUT_PATH)

txt:
	mkdir -p txt
	echo $(LIST) | xargs -n$(XARGS_N) $(TEX4RATES) --nomatrix --precise
