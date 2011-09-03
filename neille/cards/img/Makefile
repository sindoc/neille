BASE=../..
META=$(BASE)/meta
BASH_BASE=$(META)/bash
GEN=$(BASH_BASE)/neille-gen-card-graphics.bash

IN_DIR=jpeg-orig
IN_SUFFIX=jpg
OUT_GEOMETRIES="108x150"
OUT_PREFIX=jpeg-

.PHONY: gen clean

gen:
	$(GEN) \
	$(IN_DIR) $(IN_SUFFIX) \
	$(OUT_GEOMETRIES) $(OUT_PREFIX)

clean:
