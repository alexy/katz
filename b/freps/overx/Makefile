include ../../tex.mk

INPUT_PATH=freps/overx/tex

.PHONY: tex
tex:
	cat freps-overx-dreps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	cat freps-overx-freps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
