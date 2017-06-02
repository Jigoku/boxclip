APP_NAME=boxclip
APP_VERSION=0.2
LOVE_VERSION=0.10.2

build setup:
	mkdir build
	cd build && mkdir linux32 linux64 win32 win64 osx freebsd

all:portable linux32 linux64 win32 win64 osx freebsd

portable:
	#compress the lua sources to a *.love file
	#this can run anywhere where love is already installed system wide
	cd src && zip -9 -q -r ../build/$(APP_NAME)-$(APP_VERSION).love . -x \*.git* \build

win32:
	#create a windows 32bit standalone executable
	cd build/win32 && \
		wget -N https://bitbucket.org/rude/love/downloads/love-$(LOVE_VERSION)-win32.zip && \
		unzip love-$(LOVE_VERSION)-win32.zip && \
		cd love-$(LOVE_VERSION)-win32 && \
		cat love.exe ../../$(APP_NAME)-$(APP_VERSION).love > $(APP_NAME)-$(APP_VERSION)-win32.exe && \
		rm -f love.exe
    
win64:
	#create a windows 64bit standalone executable
	cd build/win64 && \
		wget -N https://bitbucket.org/rude/love/downloads/love-$(LOVE_VERSION)-win64.zip && \
		unzip love-$(LOVE_VERSION)-win64.zip && \
		cd love-$(LOVE_VERSION)-win64 && \
		cat love.exe ../../$(APP_NAME)-$(APP_VERSION).love > $(APP_NAME)-$(APP_VERSION)-win64.exe && \
		rm -f love.exe
		
linux32:

linux64:


osx:

freebsd:

install:

clean:
	rm -rf build/
