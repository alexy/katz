include $(MK_DIR)/list2.mk
include $(MK_DIR)/tex-defs.mk

XARGS_N1 ?= 5
XARGS_N2 ?= 4

.PHONY: tex txt

tex:
	mkdir -p tex
	echo $(LIST1) | xargs -n$(XARGS_N1) $(TEX4RATES) -t -i $(INPUT_PATH)
	echo $(LIST2) | xargs -n$(XARGS_N2) $(TEX4RATES) -t -i $(INPUT_PATH)

txt:
	mkdir -p txt
	echo $(LIST1) | xargs -n$(XARGS_N1) $(TEX4RATES) --nomatrix --precise
	echo $(LIST2) | xargs -n$(XARGS_N2) $(TEX4RATES) --nomatrix --precise
