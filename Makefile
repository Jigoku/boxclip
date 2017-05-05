APP_NAME=boxclip
APP_VERSION=0.2
LOVE_VERSION=0.10.2

build setup:
	mkdir build
	cd build && mkdir lin32 lin64 win32 win64 osx freebsd

all:portable linux32 linux64 win32 win64 osx freebsd

portable:
	cd src && zip -9 -q -r ../build/$(APP_NAME)-$(APP_VERSION).love . -x \*.git* \build

linux32:

linux64:

win32:

win64:

osx:

freebsd:

install:

clean:
	rm -rf build/
