BASE=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))../..
UTILS=$(BASE)/utils
BASH_BASE=$(UTILS)/bash
GO_MAKE_SUBDIRS=$(BASH_BASE)/neille-go-make-subdirs
RM_AUX_FILES=$(BASH_BASE)/neille-rm-aux-files

.PHONY: clean

all: build

clean:
	$(RM_AUX_FILES)
	$(GO_MAKE_SUBDIRS) clean $(BASH_BASE)

build:
	$(GO_MAKE_SUBDIRS) all $(BASH_BASE)
