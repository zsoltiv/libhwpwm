SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .c .o

CC ?= cc
AR ?= ar
CFLAGS ?= -g -std=c99
LDFLAGS ?= -lm
PREFIX ?= /usr/local

DIST = libhwpwm-$(shell git tag | head -n1)

SC = doc/libhwpwm.h.3.scd \
	 doc/hwpwm_channel_get_duty_cycle.3.scd \
	 doc/hwpwm_channel_get_period.3.scd \
	 doc/hwpwm_channel_get_enable.3.scd \
	 doc/hwpwm_channel_get_polarity.3.scd \
	 doc/hwpwm_channel_set_duty_cycle.3.scd \
	 doc/hwpwm_channel_set_period.3.scd \
	 doc/hwpwm_channel_set_enable.3.scd \
	 doc/hwpwm_channel_set_polarity.3.scd \
	 doc/hwpwm_chip_open_index.3.scd \
	 doc/hwpwm_chip_get_error.3.scd \
	 doc/hwpwm_chip_export_channel.3.scd \
	 doc/hwpwm_chip_unexport_channel.3.scd \
	 doc/hwpwm_chip_close.3.scd

all: libhwpwm.so libhwpwm.a

lib/hwpwm.o: lib/hwpwm.c
	$(CC) $< -c -fPIC $(CFLAGS) -Iinclude -o $@

libhwpwm.so: lib/hwpwm.o
	$(CC) $< -shared $(CFLAGS) $(LDFLAGS) -Iinclude -o $@

libhwpwm.a: lib/hwpwm.o
	$(AR) rcs $@ $<

man: $(SC)
	scdoc < doc/libhwpwm.h.3.scd > doc/libhwpwm.h.3
	scdoc < doc/hwpwm_channel_get_duty_cycle.3.scd > doc/hwpwm_channel_get_duty_cycle.3
	scdoc < doc/hwpwm_channel_get_period.3.scd > doc/hwpwm_channel_get_period.3
	scdoc < doc/hwpwm_channel_get_enable.3.scd > doc/hwpwm_channel_get_enable.3
	scdoc < doc/hwpwm_channel_get_polarity.3.scd > doc/hwpwm_channel_get_polarity.3
	scdoc < doc/hwpwm_channel_set_duty_cycle.3.scd > doc/hwpwm_channel_set_duty_cycle.3
	scdoc < doc/hwpwm_channel_set_period.3.scd > doc/hwpwm_channel_set_period.3
	scdoc < doc/hwpwm_channel_set_enable.3.scd > doc/hwpwm_channel_set_enable.3
	scdoc < doc/hwpwm_channel_set_polarity.3.scd > doc/hwpwm_channel_set_polarity.3
	scdoc < doc/hwpwm_chip_open_index.3.scd > doc/hwpwm_chip_open_index.3
	scdoc < doc/hwpwm_chip_get_error.3.scd > doc/hwpwm_chip_get_error.3
	scdoc < doc/hwpwm_chip_export_channel.3.scd > doc/hwpwm_chip_export_channel.3
	scdoc < doc/hwpwm_chip_unexport_channel.3.scd > doc/hwpwm_chip_unexport_channel.3
	scdoc < doc/hwpwm_chip_close.3.scd > doc/hwpwm_chip_close.3

clean:
	rm -rf libhwpwm.a libhwpwm.so lib/hwpwm.o doc/*.3

install: all
	install -d $(DESTDIR)$(PREFIX)/lib/
	install -m 644 libhwpwm.so $(DESTDIR)$(PREFIX)/lib/
	install -m 644 libhwpwm.a $(DESTDIR)$(PREFIX)/lib/
	install -d $(DESTDIR)$(PREFIX)/include/
	install -m 644 include/hwpwm.h $(DESTDIR)$(PREFIX)/include/

install-man: man
	install -d $(DESTDIR)$(PREFIX)/man/man3/
	install -m 644 doc/*.3 $(DESTDIR)$(PREFIX)/man/man3/

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
