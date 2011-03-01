include ../../tex.mk

INPUT_PATH=ureps-deux/srates/tex

.PHONY: tex
tex:
	cat ureps-deux-srates.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)