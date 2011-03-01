include ../../tex.mk

INPUT_PATH=lreps/srates/tex

.PHONY: tex
tex:
	cat lreps-srates.list | xargs -n5 $(TEX4RATES) -t -i $(INPUT_PATH)