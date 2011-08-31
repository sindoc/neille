BASE=../..
UTILS=$(BASE)/utils
BASH_BASE=$(UTILS)/bash
GEN=$(BASH_BASE)/neille-gen-card-graphics.bash

IN_DIR=jpeg-orig
IN_SUFFIX=jpg
OUT_GEOMETRIES="108x150"
OUT_PREFIX=jpeg-

.PHONY: gen 

gen:
	$(GEN) \
	$(IN_DIR) $(IN_SUFFIX) \
	$(OUT_GEOMETRIES) $(OUT_PREFIX)
