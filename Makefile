SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .c .o

CC ?= cc
AR ?= ar
CFLAGS ?= -g -std=c99
LDFLAGS ?= -lm
PREFIX ?= /usr/local

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

.PHONY: clean
