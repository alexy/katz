XARGS_N ?= 5

.PHONY: tex txt
tex:
	mkdir -p tex
	echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT) -t -i $(INPUT_PATH)
	[ -z "$(NORM)" ] || echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT) $(NORM) -t -i $(INPUT_PATH)

txt:
	mkdir -p txt
	echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT) --nomatrix --precise
	[ -z "$(NORM)" ] || echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT) $(NORM) --nomatrix --precise
