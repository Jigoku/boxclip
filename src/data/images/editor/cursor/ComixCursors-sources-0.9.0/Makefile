#! /usr/bin/make -f
#
# Makefile
# Part of ComixCursors, a desktop cursor theme.
#
# Copyright © 2010–2013 Ben Finney <ben+opendesktop@benfinney.id.au>
# Copyright © 2006–2013 Jens Luetkens <j.luetkens@limitland.de>
# Copyright © 2003 Unai G
#
# This work is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this work. If not, see <http://www.gnu.org/licenses/>.

# Makefile for ComixCursors project.

SHELL = /bin/bash

CURSORSNAME = ComixCursors
PACKAGENAME ?= ${CURSORSNAME}
SUMMARY ?= The original Comix Cursors
ICONSDIR ?= ${HOME}/.icons
THEMENAME ?= Custom

GENERATED_FILES :=

ifeq (@LH-,$(findstring @LH-,@${THEMEOPTIONS}))
	orientation = LeftHanded
else
	orientation = RightHanded
endif

bindir = bin
svgdir = svg
indir = ${svgdir}/${orientation}
workdir = tmp
builddir = build
xcursor_builddir = cursors
distdir = dist
configdir = ComixCursorsConfigs
configfile = ${configdir}/${THEMENAME}.CONFIG
themefile = ${builddir}/${THEMENAME}.theme

destdir = ${ICONSDIR}/${CURSORSNAME}${THEMEOPTIONS}${THEMEINCLUDE}${SIZENAME}-${THEMENAME}
xcursor_destdir = ${destdir}/cursors

template_configfile = ${configdir}/Custom.CONFIG
template_themefile = ${configdir}/Custom.theme

# Derive cursor file names.
conffiles = $(wildcard ${builddir}/*.conf)
cursornames = $(foreach conffile,${conffiles},$(basename $(notdir ${conffile})))
cursorfiles = $(foreach cursor,${cursornames},${xcursor_builddir}/${cursor})

GENERATED_FILES += ${svgdir}/*/*.frame*.svg
GENERATED_FILES += ${workdir}
GENERATED_FILES += ${builddir}
GENERATED_FILES += ${xcursor_builddir}
GENERATED_FILES += ${distdir}

# Packaging files.
news_file = NEWS
rpm_specfile_changelog = specfile-changelog
rpm_specfile = ${PACKAGENAME}.spec
rpm_spec_template = ${CURSORSNAME}.spec.in

GENERATED_FILES += ${rpm_specfile_changelog} *.spec

LINK_CURSORS = "${bindir}/link-cursors"
MAKE_SPECFILE_CHANGELOG = "${bindir}/news-to-specfile-changelog"
MAKE_SPECFILE = "${bindir}/make-specfile"


.PHONY: all
all: ${cursorfiles}

${xcursor_builddir}/%: ${builddir}/%.conf $(wildcard ${builddir}/%*.png)
	xcursorgen "$<" "$@"


.PHONY: install
install: all
# Create necessary directories.
	install -d "${ICONSDIR}" "${ICONSDIR}/default"
	$(RM) -r "${destdir}"
	install -d "${xcursor_destdir}"

# Install the cursors.
	install -m u=rw,go=r "${xcursor_builddir}"/* "${xcursor_destdir}"

# Install the theme configuration file.
	install -m u=rw,go=r "${themefile}" "${destdir}/index.theme"

# Install alternative name symlinks for the cursors.
	$(LINK_CURSORS) "${xcursor_destdir}"

.PHONY: uninstall
uninstall:
	$(RM) -r "${destdir}"


.PHONY: custom-theme
custom-theme: ${configfile} ${themefile}

${configfile}: ${template_configfile}
	cp "$<" "$@"

${themefile}: ${template_themefile}
	install -d "${builddir}"
	cp "$<" "$@"


.PHONY: rpm
rpm: ${rpm_specfile}

${rpm_specfile_changelog}: ${news_file}
	$(MAKE_SPECFILE_CHANGELOG) < "$<" > "$@"

${rpm_specfile}: ${rpm_spec_template} ${rpm_specfile_changelog}
	$(MAKE_SPECFILE)


.PHONY: clean
clean:
	$(RM) -r ${GENERATED_FILES}


# Local Variables:
# mode: makefile
# coding: utf-8
# End:
# vim: filetype=make fileencoding=utf-8 :
