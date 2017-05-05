#!/bin/sh
#copy locally saved maps into the src folder
#used for updating the default builtin maps for release

for f in ~/.local/share/love/boxclip/maps/*.lua; do echo ${f} && cp ${f} ./src/maps/ ; done
