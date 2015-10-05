#!/bin/sh
_OUT=dist/platform_engine.love
zip -9 -q -r ${_OUT} . && echo "created ${_OUT}"
