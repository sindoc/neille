UTILS=./neille/utils
MAKE_BASE=$(UTILS)/make

include $(MAKE_BASE)/common.mk

build-:
	cd neille && $(MAKE)

build: build-
