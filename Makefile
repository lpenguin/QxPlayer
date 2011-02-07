target = QxPlayer
sources = $(wildcard src/*.mxml src/*.as)
flags=
libs=lib/*.swc


show_warnings = 1
use_network = 0 
debug_mode = 1
air=0

#flags += -compiler.external-library-path=lib
#flags += -static-link-runtime-shared-libraries=true

ifeq ($(show_warnings), 1)
#	flags += -show-actionscript-warnings=true
	else
#		flags+= -show-actionscript-warnings=false
endif

ifeq ($(use_network), 1)
	flags+= -use-network=true
	else
		flags+= -use-network=false
endif

ifeq ($(debug_mode), 1)
	flags+= -compiler.debug
endif

compiler=mxmlc
ifeq ($(air), 1)
	compiler=amxmlc
endif


all: bin/$(target).swf

.PHONY: bin/$(target).swf
bin/$(target).swf: $(sources)
	$(compiler) src/$(target).mxml $(flags)  -load-config obj/QxPlayerConfig-linux.xml -output bin/$(target).swf
	
run: bin/$(target).swf
	flashplayer bin/$(target).swf
