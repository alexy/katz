include ../../tex.mk

INPUT_PATH=lreps/overx/tex

.PHONY: tex
tex:
	cat lreps-overx-dreps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	cat lreps-overx-lreps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
