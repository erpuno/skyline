empty :=
space := $(empty) $(empty)
REBAR ?= $(or $(shell which rebar 2>/dev/null),./rebar)
SRC_APP_DIR_ROOTS ?= apps deps
ERL_LIBS := $(subst $(space),:,$(SRC_APP_DIR_ROOTS))
RUN_DIR ?= ./rels/web/devbox
LOG_DIR ?= ./rels/web/devbox/logs

deps: get-deps

get-deps compile clean:
	$(REBAR) $@

console:  .applist
	ERL_LIBS=$(ERL_LIBS) erl $(ERL_ARGS) -eval '[ok = application:ensure_started(A, permanent) || A <- $(shell cat .applist)]'

.applist:
	./envgen.erl $(APPS) > $@t

$(RUN_DIR) $(LOG_DIR):
	mkdir -p $(RUN_DIR)
	mkdir -p $(LOG_DIR)
	mkdir -p kai

start: $(RUN_DIR) $(LOG_DIR)
	run_erl -daemon $(RUN_DIR)/ $(LOG_DIR)/ "exec $(MAKE) console"

attach:
	to_erl $(RUN_DIR)/

.PHONY: get-deps compile clean deps console start attach
