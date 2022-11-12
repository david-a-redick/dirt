# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@true

# Install debian packages.
# The libsdl-ttf2.0 is only needed if you do WIDE=Y
dependencies_debian:
	sudo apt-get install libsdl1.2-dev libsdl-ttf2.0-dev xaw3dg-dev

# Space delimited list of other dirt packages.
list_dependencies_dirt:
	@echo ''

##
# All of the following stages will be done in a proot environment.
# The real working directory will be: $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
# The proot working directory will be: /workspace
##

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
fetch:
	git clone https://github.com/wmcbrine/PDCurses.git
	cd PDCurses && git checkout 3.9

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	@true

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	cd PDCurses/x11 && ./configure --prefix="$(PREFIX)" --enable-widec --with-xaw3d --with-x


# NOTE: even though it looks like X11 and SDL1 are separate
# It looks like you really need both for the apps to actually run.
# redick Assumes the same is true for SDL2 apps.
build:
	cd PDCurses/x11 && make
	cd PDCurses/sdl1 && WIDE=Y make
	# need to get this in the Makefile via patch
	gcc -O2 -Wall -fPIC -DPDC_WIDE -I.. -shared -o pdcurses.so *.o


# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	cd PDCurses/sdl1 && WIDE=Y make demos
	echo 'You will have to run: testcurs ozdemo xmas tuidemo firework ptest rain worm sdltest'

# Install the package to the local system.
install_package:
	cd PDCurses/x11 && make prefix="$(PREFIX)" install
	install -Dm644 curspriv.h "$(PREFIX)/include/curspriv.h"
	install -Dm644 pdcurses.h "$(PREFIX)/include/pdcurses.h"
	install -Dm644 sdl1/pdcsdl.h "$(PREFIX)/include/pdcsdl.h"
	# note: to support both SDL 1 and 2 we'll have to rename these to say SDL1 and SDL2
	install -Dm644 sdl1/pdcurses.a "$(PREFIX)/lib/libpdcurses.a"
	install -Dm644 sdl1/pdcurses.so "$(PREFIX)/lib/libpdcurses.so"

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

