## automake - create Makefile.in from Makefile.am
## Copyright (C) 1994-2014 Free Software Foundation, Inc.

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2, or (at your option)
## any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

RECURSIVE_TARGETS += \
  all-recursive \
  check-recursive \
  installcheck-recursive \
  mostlyclean-recursive \
  clean-recursive \
  distclean-recursive \
  maintainer-clean-recursive

am.recurs.all-targets = \
  $(RECURSIVE_TARGETS) \
  $(am.recurs.extra-targets)

# All documented targets which invoke 'make' recursively, or depend
# on targets that do so.  GNUmakefile from gnulib depends on this.
AM_RECURSIVE_TARGETS += $(am.recurs.all-targets:-recursive=)

.PHONY: $(am.recurs.all-targets)

# This directory's subdirectories are mostly independent; you can cd
# into them and run 'make' without going through this Makefile.
# To change the values of 'make' variables: instead of editing Makefiles,
# (1) if the variable is set in 'config.status', edit 'config.status'
#     (which will cause the Makefiles to be regenerated when you run 'make');
# (2) otherwise, pass the desired values on the 'make' command line.

$(am.recurs.all-targets): %-recursive:
## Using $failcom allows "-k" to keep its natural meaning when running a
## recursive rule.
	@fail=; \
	if $(am.make.keep-going); then \
	  failcom='fail=yes'; \
	else \
	  failcom='exit 1'; \
	fi; \
	dot_seen=no; \
## For distclean and maintainer-clean we make sure to use the full
## list of subdirectories.  We do this so that 'configure; make
## distclean' really is a no-op, even if SUBDIRS is conditional.
	case "$@" in \
	  distclean-* | maintainer-clean-*) list='$(DIST_SUBDIRS)' ;; \
	  *) list='$(SUBDIRS)' ;; \
	esac; \
	for subdir in $$list; do \
	  echo "Making $* in $$subdir"; \
	  if test "$$subdir" = "."; then \
	    dot_seen=yes; \
	    local_target=$*-am; \
	  else \
	    local_target=$*; \
	  fi; \
	  $(MAKE) -C "$$subdir" $$local_target || eval $$failcom; \
	done; \
	if test "$$dot_seen" = "no"; then \
	  $(MAKE) $*-am || exit 1; \
	fi; test -z "$$fail"

mostlyclean: mostlyclean-recursive
clean: clean-recursive
distclean: distclean-recursive
maintainer-clean: maintainer-clean-recursive