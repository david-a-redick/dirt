
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	# The libsdl-ttf2.0 is only needed if you do WIDE=Y
	echo "libsdl1.2-dev libsdl-ttf2.0-dev xaw3dg-dev"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	git clone https://github.com/wmcbrine/PDCurses.git
	cd PDCurses
	git checkout 3.9
}

verify () {
	# Perform any check sums or gpg signature verifications.
	return 0
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	return 0
}

prepare () {
	# Known as prepare `patch` in ports.
	return 0
}

configure () {
	# Configure the source codes build setup.
	local install_prefix="$1"
	cd PDCurses/x11
	./configure --prefix="$install_prefix" --enable-widec --with-xaw3d --with-x
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	cd PDCurses

	# NOTE: even though it looks like X11 and SDL1 are separate
	# It looks like you really need both for the apps to actually run.
	# redick Assumes the same is true for SDL2 apps.
	
	cd x11
	make
	cd ..

	cd sdl1
	WIDE=Y make
	# need to get this in the Makefile via patch
	gcc -O2 -Wall -fPIC -DPDC_WIDE -I.. -shared -o pdcurses.so *.o
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	local install_prefix="$1"
	cd PDCurses/sdl1
	WIDE=Y make demos
	echo 'You will have to run: testcurs ozdemo xmas tuidemo firework ptest rain worm sdltest'
}

install_package () {
	# Install the package to the local system.
	local install_prefix="$1"
	cd PDCurses
	
	cd x11
	make prefix="$install_prefix" install
	cd ..
	install -Dm644 curspriv.h "$install_prefix/include/curspriv.h"
	install -Dm644 pdcurses.h "$install_prefix/include/pdcurses.h"

	install -Dm644 sdl1/pdcsdl.h "$install_prefix/include/pdcsdl.h"
	# note: to support both SDL 1 and 2 we'll have to rename these to say SDL1 and SDL2
	install -Dm644 sdl1/pdcurses.a "$install_prefix/lib/libpdcurses.a"
	install -Dm644 sdl1/pdcurses.so "$install_prefix/lib/libpdcurses.so"
}

check_install () {
	# Any post install checks ands tests.
	local install_prefix="$1"
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}