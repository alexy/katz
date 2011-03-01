include ../../tex.mk

INPUT_PATH=freps-deux/overx/tex

.PHONY: tex
tex:
	cat freps-deux-overx-dreps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	cat freps-deux-overx-freps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)