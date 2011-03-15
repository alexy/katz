XARGS_N ?= 5

.PHONY: tex txt
tex:
	mkdir -p tex
	                    echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT)         -t -i $(INPUT_PATH)
	[ -z "$(RUN2)" ] || echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT) $(RUN2) -t -i $(INPUT_PATH)

txt:
	mkdir -p txt
	                    echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT)         --nomatrix --precise
	[ -z "$(RUN2)" ] || echo $(LIST) | xargs -n$(XARGS_N) $(TEXIT) $(RUN2) --nomatrix --precise
