META=./neille/meta
MAKE_BASE=$(META)/make

include $(MAKE_BASE)/common.mk

build-:
	cd neille && $(MAKE)

build: build-
