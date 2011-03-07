EXT=mlb
#SOURCES=$(shell ls *.$(EXT))
SOURCES=$(shell cat xz.list)
XZ=$(SOURCES:%=%.xz)

all: $(XZ)

$(XZ): %.xz: %
	xz $^
