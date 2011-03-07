BZ2=$(shell ls *.bz2)
XZ=$(BZ2:%.bz2=%.xz)

all: $(XZ)

$(XZ): %.xz: %.bz2
	bzcat $^ | xz - > $@ && rm $^
