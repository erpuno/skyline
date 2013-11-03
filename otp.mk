empty :=
space := $(empty) $(empty)
REBAR ?= $(or $(shell which rebar 2>/dev/null),./rebar)
SRC_APP_DIR_ROOTS ?= apps deps
ERL_LIBS := $(subst $(space),:,$(SRC_APP_DIR_ROOTS))

compile: get-deps static-link
get-deps compile clean update-deps:
	$(REBAR) $@
.applist:
	./envgen.erl $(APPS) > $@t
$(RUN_DIR) $(LOG_DIR):
	mkdir -p $(RUN_DIR)
	mkdir -p $(LOG_DIR)
	mkdir -p kai
console:  .applist
	ERL_LIBS=$(ERL_LIBS) erl $(ERL_ARGS) -eval '[ok = application:ensure_started(A, permanent) || A <- $(shell cat .applist)]'
start: $(RUN_DIR) $(LOG_DIR)
	run_erl -daemon $(RUN_DIR)/ $(LOG_DIR)/ "exec $(MAKE) console"
attach:
	to_erl $(RUN_DIR)/
release:
	relx
stop:
	kill -9 `ps ax -o pid= -o command=|grep $(RELEASE)|grep $(COOKIE)|awk '{print $$1}'`

.PHONY: get-deps compile clean console start attach release update-deps
