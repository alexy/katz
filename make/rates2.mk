XARGS_N1 ?= 5
XARGS_N2 ?= 4

TEX_DIR   ?= tex
TXT_DIR   ?= txt

O_TEX_DIR ?= $(if $(TEX_DIR), -o $(TEX_DIR),)
O_TXT_DIR ?= $(if $(TXT_DIR), -o $(TXT_DIR),)

.PHONY: tex txt

tex:
	mkdir -p $(TEX_DIR)

	echo $(LIST1) | xargs -n$(XARGS_N1) $(TEXIT) $(O_TEX_DIR) -t -i $(INPUT_PATH)
	echo $(LIST2) | xargs -n$(XARGS_N2) $(TEXIT) $(O_TEX_DIR) -t -i $(INPUT_PATH)

	[ -z "$(RUN2)" ] || echo $(LIST1) | xargs -n$(XARGS_N1) $(TEXIT) $(O_TEX_DIR) $(RUN2) -t -i $(INPUT_PATH)
	[ -z "$(RUN2)" ] || echo $(LIST2) | xargs -n$(XARGS_N2) $(TEXIT) $(O_TEX_DIR) $(RUN2) -t -i $(INPUT_PATH)

txt:
	mkdir -p $(TXT_DIR)
	                    echo $(LIST1) | xargs -n$(XARGS_N1) $(TEXIT) $(O_TXT_DIR)         --nomatrix --precise
	                    echo $(LIST2) | xargs -n$(XARGS_N2) $(TEXIT) $(O_TXT_DIR)         --nomatrix --precise
	                    
	[ -z "$(RUN2)" ] || echo $(LIST1) | xargs -n$(XARGS_N1) $(TEXIT) $(O_TXT_DIR) $(RUN2) --nomatrix --precise
	[ -z "$(RUN2)" ] || echo $(LIST2) | xargs -n$(XARGS_N2) $(TEXIT) $(O_TXT_DIR) $(RUN2) --nomatrix --precise
