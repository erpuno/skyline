RELEASE := skyline
COOKIE := node_runner
APPS := web active amqp_client avz cowboy erlydtl gproc kai kvs lager mimetypes mqs n2o oauth rabbit_common ranch sync
ERL_ARGS := -args_file rels/web/files/vm.args -config rels/web/files/sys.config
RUN_DIR ?= ./rels/web/devbox
LOG_DIR ?= ./rels/web/devbox/logs
N2O          := deps/n2o/priv/static
FILES        := apps/web/priv/static/n2o
BOOTSTRAP    := apps/web/priv/static/bootstrap
FONTAWESOME  := apps/web/priv/static/font-awesome
MCE          := apps/web/priv/static/tinymce
LESSJS       := apps/web/priv/static/less

default: compile static-link

static-link:
	rm -rf $(N2O)
	rm -rf $(FILES)
	rm -rf $(BOOTSTRAP)
	rm -rf $(FONTAWESOME)
	rm -rf $(LESSJS)
	rm -rf $(MCE)
	ln -sf ../../n2o_scripts $(N2O)
	mkdir -p $(shell dirname $(FILES))
	ln -sf ../../../../deps/n2o/priv/static/tinymce $(MCE)
	ln -sf ../../../../deps/n2o/priv/static/n2o $(FILES)
	ln -sf ../../../../deps/n2o/priv/static/bootstrap $(BOOTSTRAP)
	ln -sf ../../../../deps/n2o/priv/static/font-awesome $(FONTAWESOME)
	ln -sf ../../../../deps/n2o/priv/static/less $(LESSJS)

include otp.mk

