include ../../tex.mk

INPUT_PATH=ereps/overx/tex

.PHONY: tex
tex:
	cat ereps-overx-dreps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	cat ereps-overx-ereps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)