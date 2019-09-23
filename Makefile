VERCMD  ?= git describe --tags 2> /dev/null
VERSION := 0.9.9

CPPFLAGS += -D_POSIX_C_SOURCE=200809L -DVERSION=\"$(VERSION)\"
CFLAGS   += -std=c99 -pedantic -Wall -Wextra -DJSMN_STRICT
LDFLAGS  ?=
LDLIBS    = $(LDFLAGS) -lm -lxcb -lxcb-util -lxcb-keysyms -lxcb-icccm -lxcb-ewmh -lxcb-randr -lxcb-xinerama -lxcb-shape

PREFIX    ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin
MANPREFIX ?= $(PREFIX)/share/man

MD_DOCS    = README.md doc/CHANGELOG.md doc/CONTRIBUTING.md doc/INSTALL.md doc/MISC.md doc/TODO.md
XSESSIONS ?= $(PREFIX)/share/xsessions

WM_SRC   = bspwm.c helpers.c geometry.c jsmn.c settings.c monitor.c desktop.c tree.c stack.c history.c \
	 events.c pointer.c window.c messages.c parse.c query.c restore.c rule.c ewmh.c subscribe.c
WM_OBJ  := $(WM_SRC:.c=.o)
CLI_SRC  = bspc.c helpers.c
CLI_OBJ := $(CLI_SRC:.c=.o)

all: bspwm bspc

debug: CFLAGS += -O0 -g
debug: bspwm bspc

VPATH=src

bspc.o: bspc.c common.h helpers.h
bspwm.o: bspwm.c bspwm.h common.h desktop.h events.h ewmh.h helpers.h history.h messages.h monitor.h pointer.h rule.h settings.h subscribe.h types.h window.h
desktop.o: desktop.c bspwm.h desktop.h ewmh.h helpers.h history.h monitor.h query.h settings.h subscribe.h tree.h types.h window.h
events.o: events.c bspwm.h events.h ewmh.h helpers.h monitor.h pointer.h query.h settings.h subscribe.h tree.h types.h window.h
ewmh.o: ewmh.c bspwm.h ewmh.h helpers.h settings.h tree.h types.h
geometry.o: geometry.c geometry.h helpers.h types.h
helpers.o: helpers.c bspwm.h helpers.h types.h
history.o: history.c bspwm.h helpers.h query.h tree.h types.h
jsmn.o: jsmn.c jsmn.h
messages.o: messages.c bspwm.h common.h desktop.h helpers.h jsmn.h messages.h monitor.h parse.h pointer.h query.h restore.h rule.h settings.h subscribe.h tree.h types.h window.h
monitor.o: monitor.c bspwm.h desktop.h ewmh.h geometry.h helpers.h monitor.h pointer.h query.h settings.h subscribe.h tree.h types.h window.h
parse.o: parse.c helpers.h parse.h subscribe.h types.h
pointer.o: pointer.c bspwm.h events.h helpers.h monitor.h pointer.h query.h settings.h stack.h subscribe.h tree.h types.h window.h
query.o: query.c bspwm.h desktop.h helpers.h history.h monitor.h parse.h query.h subscribe.h tree.h types.h window.h
restore.o: restore.c bspwm.h desktop.h ewmh.h helpers.h history.h jsmn.h monitor.h parse.h pointer.h query.h restore.h settings.h stack.h subscribe.h tree.h types.h window.h
rule.o: rule.c bspwm.h ewmh.h helpers.h parse.h rule.h settings.h subscribe.h types.h window.h
settings.o: settings.c bspwm.h helpers.h settings.h types.h
stack.o: stack.c bspwm.h ewmh.h helpers.h stack.h subscribe.h tree.h types.h window.h
subscribe.o: subscribe.c bspwm.h desktop.h helpers.h settings.h subscribe.h types.h
tree.o: tree.c bspwm.h desktop.h ewmh.h geometry.h helpers.h history.h monitor.h pointer.h query.h settings.h stack.h subscribe.h tree.h types.h window.h
window.o: window.c bspwm.h ewmh.h geometry.h helpers.h monitor.h parse.h pointer.h query.h rule.h settings.h stack.h subscribe.h tree.h types.h window.h

$(WM_OBJ) $(CLI_OBJ): Makefile

bspwm: $(WM_OBJ)

bspc: $(CLI_OBJ)

install:
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp -pf bspwm "$(DESTDIR)$(BINPREFIX)"
	cp -pf bspc "$(DESTDIR)$(BINPREFIX)"
	mkdir -p "$(DESTDIR)$(MANPREFIX)"/man1
	cp -p man/bspwm.1 "$(DESTDIR)$(MANPREFIX)"/man1
	ln -s bspwm.1 "$(DESTDIR)$(MANPREFIX)"/man1/bspc.1

uninstall:
	rm -f "$(DESTDIR)$(BINPREFIX)"/bspwm
	rm -f "$(DESTDIR)$(BINPREFIX)"/bspc
	rm -f "$(DESTDIR)$(MANPREFIX)"/man1/bspwm.1
	rm -f "$(DESTDIR)$(MANPREFIX)"/man1/bspc.1

clean:
	rm -f $(WM_OBJ) $(CLI_OBJ) bspwm bspc

.PHONY: all debug install uninstall doc clean
