SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .c .o

CC ?= cc
AR ?= ar
CFLAGS ?= -g -std=c99
LDFLAGS ?= -lm
PREFIX ?= /usr/local

DIST = libhwpwm-$(shell git tag | head -n1)

all: libhwpwm.so libhwpwm.a

lib/hwpwm.o: lib/hwpwm.c
	$(CC) $< -c -fPIC $(CFLAGS) -Iinclude -o $@

libhwpwm.so: lib/hwpwm.o
	$(CC) $< -shared $(CFLAGS) $(LDFLAGS) -Iinclude -o $@

libhwpwm.a: lib/hwpwm.o
	$(AR) rcs $@ $<

clean:
	rm -rf libhwpwm.a libhwpwm.so lib/hwpwm.o

install: all
	install -d $(DESTDIR)$(PREFIX)/lib/
	install -m 644 libhwpwm.so $(DESTDIR)$(PREFIX)/lib/
	install -m 644 libhwpwm.a $(DESTDIR)$(PREFIX)/lib/
	install -d $(DESTDIR)$(PREFIX)/include/
	install -m 644 include/hwpwm.h $(DESTDIR)$(PREFIX)/include/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/lib/libhwpwm.a
	rm -f $(DESTDIR)$(PREFIX)/lib/libhwpwm.so
	rm -f $(DESTDIR)$(PREFIX)/include/hwpwm.h

dist:
	mkdir -p $(DIST)
	cp -r lib $(DIST)/lib
	cp -r include $(DIST)/include
	cp README.md $(DIST)/
	cp Makefile $(DIST)/
	cp COPYING $(DIST)/
	cp COPYING.LESSER $(DIST)/
	tar czf $(DIST).tar.gz $(DIST)
	rm -rf $(DIST)

.PHONY: clean uninstall dist
