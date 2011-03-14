XARGS_N1 ?= 5
XARGS_N2 ?= 4

.PHONY: tex txt

tex:
	mkdir -p tex
	echo $(LIST1) | xargs -n$(XARGS_N1) $(TEXIT) -t -i $(INPUT_PATH)
	echo $(LIST2) | xargs -n$(XARGS_N2) $(TEXIT) -t -i $(INPUT_PATH)

txt:
	mkdir -p txt
	echo $(LIST1) | xargs -n$(XARGS_N1) $(TEXIT) --nomatrix --precise
	echo $(LIST2) | xargs -n$(XARGS_N2) $(TEXIT) --nomatrix --precise
