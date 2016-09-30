#!/bin/sh

for f in ~/.local/share/love/boxclip/maps/*.lua; do echo ${f} && cp ${f} ./maps/ ; done
