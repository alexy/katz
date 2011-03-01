include ../../tex.mk

INPUT_PATH=ereps/srates/tex

.PHONY: tex
tex:
	cat ereps-srates.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)