RELEASE := web
COOKIE  := node_runner
VER     := 1.0.0
FILES   := apps/web/priv/static/n2o

default: compile static-link
static-link:
	rm -rf $(FILES)
	ln -sf ../../../../deps/n2o/priv $(FILES)

include otp.mk
