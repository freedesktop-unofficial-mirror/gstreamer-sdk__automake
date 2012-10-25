#! /bin/sh
# Copyright (C) 1999-2012 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Test library-specific flags.

. ./defs || exit 1

cat >> configure.ac << 'END'
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CXX
AM_PROG_AR
AC_PROG_RANLIB
END

cat > Makefile.am << 'END'
AUTOMAKE_OPTIONS = no-dependencies
lib_LIBRARIES = libfoo.a
libfoo_a_SOURCES = foo.c bar.cc
libfoo_a_CFLAGS = -DBAR
libfoo_a_CXXFLAGS = -DZOT
END

: > ar-lib

# Make sure 'compile' is required.
$ACLOCAL
AUTOMAKE_fails
grep 'required.*compile' stderr

: > compile

$AUTOMAKE

# Look for $(COMPILE) -c in .c.o rule.
grep 'COMPILE. [^-]' Makefile.in && exit 1

# Look for libfoo_a-foo.o.
grep foo Makefile.in
grep '[^-]foo\.o' Makefile.in && exit 1

# Look for libfoo_a-bar.o.
grep bar Makefile.in
grep '[^-]bar\.o' Makefile.in && exit 1

exit 0
