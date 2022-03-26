# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

check_local:
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	true

dependencies_debian:
	# Install debian packages.
	sudo apt-get install libyaml-cpp-dev libsdl1.2-dev libsdl-mixer1.2-dev

dependencies_dirt:
	# Space delimited list of other dirt packages.
	echo "pdcurses-3.9"

fetch:
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	git clone https://github.com/cymonsgames/ASCIIpOrtal.git
	cd ASCIIpOrtal
	git checkout v1.3-beta8
	git checkout -b v1.3-beta8-dirt

	# Note that the icon image used in AUR.
	# IS NOT under a CC license and is a direct copy of Valve's copyrighted ascii art.
	# https://www.deviantart.com/dj-zemar/art/The-Official-Portal-ASCII-Art-176976417

verify:
	# Perform any check sums or gpg signature verifications.
	true

extract:
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	true

prepare:
	# Known as prepare `patch` in ports.
	cd ASCIIpOrtal && git apply "$(PACKAGE_DIR)/v1.3-beta8-dirt.patch"
}

configure:
	# Configure the source codes build setup.
	true

build:
	# Compile and otherwise package up for installation or distribution.
	# we have to define libraries and runtime shared resources
	# under $HOME/.local or where ever
	cd ASCIIpOrtal && make DESTDIR="$(DIRT_HOOK_PATH)" linux

test:
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	true

install_package:
	# Install the package to the local system.
	cd ASCIIpOrtal && make DESTDIR="$(PREFIX)" install
	mkdir -p "$(PREFIX)/share/pixmaps/"
	install --mode=644 "$(PACKAGE_DIR)/asciiportal.png" "$(PREFIX)/share/pixmaps"
	mkdir -p "$(PREFIX)/share/applications"
	install --mode=644 "$(PACKAGE_DIR)/asciiportal.desktop" "$(PREFIX)/share/applications"

check_install:
	# Any post install checks ands tests.
	true

purge:
	# Remove any configuration (dot files) and other files created during run time.
	true

