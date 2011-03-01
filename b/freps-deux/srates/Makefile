include ../../tex.mk

INPUT_PATH=freps-deux/srates/tex

.PHONY: tex
tex:
	cat freps-deux-srates.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)