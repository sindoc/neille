VC_IGNORE_FILE=.gitignore

$(VC_IGNORE_FILE):
	for out in $(OUT); do \
	  echo $$out; \
	done >$@

	for ign in $(VC_IGNORE_LIST); do \
	  echo $$ign; \
	done >>$@
