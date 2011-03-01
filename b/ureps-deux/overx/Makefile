include ../../tex.mk

INPUT_PATH=ureps-deux/overx/tex

.PHONY: tex
tex:
	cat ureps-deux-overx-dreps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
	cat ureps-deux-overx-ureps.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)
