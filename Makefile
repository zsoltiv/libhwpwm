SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .c .o

CC ?= cc
CFLAGS ?= -g -std=c11
LDFLAGS ?= -lm

all: libhwpwm.so libhwpwm.a

lib/hwpwm.o: lib/hwpwm.c
	$(CC) $< -c -fPIC $(CFLAGS) -Iinclude -o $@

libhwpwm.so: lib/hwpwm.o
	$(CC) $< -shared $(CFLAGS) $(LDFLAGS) -Iinclude -o $@

libhwpwm.a: lib/hwpwm.o
	$(CC) $< -static $(CFLAGS) $(LDFLAGS) -Iinclude -o $@


clean:
	rm -rf libhwpwm.a libhwpwm.so lib/hwpwm.o

.PHONY: clean
