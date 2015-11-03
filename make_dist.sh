#!/bin/sh
_OUT=dist/boxclip.love
zip -9 -q -r ${_OUT} . && echo "created ${_OUT}"
