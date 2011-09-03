BASE=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))../..
META=$(BASE)/meta
BASH_BASE=$(META)/bash
GO_MAKE_SUBDIRS=$(BASH_BASE)/neille-go-make-subdirs.bash
RM_AUX_FILES=$(BASH_BASE)/neille-rm-aux-files.bash
GEN_STATS=$(BASH_BASE)/neille-gen-stats.bash

.PHONY: clean

all: build

clean:
	$(RM_AUX_FILES)
	$(GO_MAKE_SUBDIRS) clean $(BASH_BASE)

build:
	$(GO_MAKE_SUBDIRS) all $(BASH_BASE)

stats:
	$(GEN_STATS)
