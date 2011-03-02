include ../../tex.mk
.PHONY: tex txt
tex:
	mkdir -p tex
	cat $(LIST) | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	
txt:
	mkdir -p txt
	cat $(LIST) | xargs -n5 $(TEX4RATES) --nomatrix --precise
