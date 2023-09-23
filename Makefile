SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .c .o

CC ?= cc
AR ?= ar
CFLAGS ?= -g
LDFLAGS += -lm
PREFIX ?= /usr/local

VERSION = 0.4.3
DIST = libhwpwm-$(VERSION)

SC = doc/libhwpwm.h.3.scd \
	 doc/hwpwm_channel_get_duty_cycle.3.scd \
	 doc/hwpwm_channel_get_period.3.scd \
	 doc/hwpwm_channel_get_enable.3.scd \
	 doc/hwpwm_channel_get_polarity.3.scd \
	 doc/hwpwm_channel_set_duty_cycle.3.scd \
	 doc/hwpwm_channel_set_duty_cycle_percent.3.scd \
	 doc/hwpwm_channel_set_period.3.scd \
	 doc/hwpwm_channel_set_period_frequency.3.scd \
	 doc/hwpwm_channel_set_enable.3.scd \
	 doc/hwpwm_channel_set_polarity.3.scd \
	 doc/hwpwm_chip_open_index.3.scd \
	 doc/hwpwm_chip_get_error.3.scd \
	 doc/hwpwm_chip_export_channel.3.scd \
	 doc/hwpwm_chip_unexport_channel.3.scd \
	 doc/hwpwm_chip_close.3.scd

LIBDIR = lib
MANDIR = share/man/man3
INCDIR = include

all: libhwpwm.so libhwpwm.a

lib/hwpwm.o: lib/hwpwm.c
	$(CC) $< -c -fPIC $(CFLAGS) -I$(INCDIR) -o $@

libhwpwm.so: lib/hwpwm.o
	$(CC) $< -shared $(CFLAGS) $(LDFLAGS) -I$(INCDIR) -o $@

libhwpwm.a: lib/hwpwm.o
	$(AR) rcs $@ $<

man: $(SC)
	scdoc < doc/libhwpwm.h.3.scd > doc/libhwpwm.h.3
	scdoc < doc/hwpwm_channel_get_duty_cycle.3.scd > doc/hwpwm_channel_get_duty_cycle.3
	scdoc < doc/hwpwm_channel_get_period.3.scd > doc/hwpwm_channel_get_period.3
	scdoc < doc/hwpwm_channel_get_enable.3.scd > doc/hwpwm_channel_get_enable.3
	scdoc < doc/hwpwm_channel_get_polarity.3.scd > doc/hwpwm_channel_get_polarity.3
	scdoc < doc/hwpwm_channel_set_duty_cycle.3.scd > doc/hwpwm_channel_set_duty_cycle.3
	scdoc < doc/hwpwm_channel_set_duty_cycle_percent.3.scd > doc/hwpwm_channel_set_duty_cycle_percent.3
	scdoc < doc/hwpwm_channel_set_period.3.scd > doc/hwpwm_channel_set_period.3
	scdoc < doc/hwpwm_channel_set_period_frequency.3.scd > doc/hwpwm_channel_set_period_frequency.3
	scdoc < doc/hwpwm_channel_set_enable.3.scd > doc/hwpwm_channel_set_enable.3
	scdoc < doc/hwpwm_channel_set_polarity.3.scd > doc/hwpwm_channel_set_polarity.3
	scdoc < doc/hwpwm_chip_open_index.3.scd > doc/hwpwm_chip_open_index.3
	scdoc < doc/hwpwm_chip_get_error.3.scd > doc/hwpwm_chip_get_error.3
	scdoc < doc/hwpwm_chip_export_channel.3.scd > doc/hwpwm_chip_export_channel.3
	scdoc < doc/hwpwm_chip_unexport_channel.3.scd > doc/hwpwm_chip_unexport_channel.3
	scdoc < doc/hwpwm_chip_close.3.scd > doc/hwpwm_chip_close.3

clean:
	rm -rf libhwpwm.a libhwpwm.so $(LIBDIR)/hwpwm.o doc/*.3

install: all
	install -d $(DESTDIR)$(PREFIX)/$(LIBDIR)/
	install -m 644 libhwpwm.so $(DESTDIR)$(PREFIX)/$(LIBDIR)/
	install -m 644 libhwpwm.a $(DESTDIR)$(PREFIX)/$(LIBDIR)/
	install -d $(DESTDIR)$(PREFIX)/$(INCDIR)
	install -m 644 include/hwpwm.h $(DESTDIR)$(PREFIX)/$(INCDIR)

install-man: man
	install -d $(DESTDIR)$(PREFIX)/$(MANDIR)/
	install -m 644 doc/*.3 $(DESTDIR)$(PREFIX)/$(MANDIR)/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/$(LIBDIR)/libhwpwm.a
	rm -f $(DESTDIR)$(PREFIX)/$(LIBDIR)/libhwpwm.so
	rm -f $(DESTDIR)$(PREFIX)/$(INCDIR)hwpwm.h

dist:
	mkdir -p $(DIST)
	cp -r $(LIBDIR) $(DIST)/$(LIBDIR)
	cp -r $(INCDIR) $(DIST)/$(INCDIR)
	cp README.md $(DIST)/
	cp Makefile $(DIST)/
	cp COPYING $(DIST)/
	mkdir -p $(DIST)/doc
	cp doc/*.scd $(DIST)/doc
	cp COPYING.LESSER $(DIST)/
	tar czf $(DIST).tar.gz $(DIST)
	rm -rf $(DIST)

.PHONY: clean uninstall dist
