empty :=
space := $(empty) $(empty)
REBAR ?= $(or $(shell which rebar 2>/dev/null),./rebar)
ROOTS ?= apps deps
ERL_LIBS := $(subst $(space),:,$(ROOTS))
PLT_NAME=.dialyzer.plt

compile: get-deps static-link
get-deps compile clean update-deps:
	$(REBAR) $@
.applist:
	./envgen.erl $(APPS) > $@t
$(RUN_DIR) $(LOG_DIR):
	mkdir -p $(RUN_DIR)
	mkdir -p $(LOG_DIR)
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
$(PLT_NAME):
	ERL_LIBS=$(ERL_LIBS) dialyzer --build_plt --output_plt $(PLT_NAME) --apps $(APPS) 
dialyze: $(PLT_NAME)
	dialyzer apps/*/ebin deps/*/ebin --plt $(PLT_NAME) --no_native -Werror_handling -Wunderspecs -Wrace_conditions

.PHONY: get-deps compile clean console start attach release update-deps dialyze
