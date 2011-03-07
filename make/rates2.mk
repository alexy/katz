include ../../tex.mk
.PHONY: tex txt
tex:
	mkdir -p tex
	cat $(LIST1) | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	cat $(LIST2) | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)

txt:
	mkdir -p txt
	cat $(LIST1) | xargs -n5 $(TEX4RATES) --nomatrix --precise
	cat $(LIST2) | xargs -n5 $(TEX4RATES) --nomatrix --precise
