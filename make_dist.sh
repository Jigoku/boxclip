#!/bin/sh
_OUT=dist/platform_engine.love
zip -9 -q -r ${_OUT} .
echo "love2d executable saved to ${_OUT}"
