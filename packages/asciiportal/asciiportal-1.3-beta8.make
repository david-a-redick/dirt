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
# sudo apt-get install ...
dependencies_debian:
	sudo apt-get install libyaml-cpp-dev libsdl1.2-dev libsdl-mixer1.2-dev

# Space delimited list of other dirt packages.
list_dependencies_dirt:
	@echo 'pdcurses-3.9'

##
# All of the following stages will be done in a proot environment.
# The real working directory will be: $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
# The proot working directory will be: /workspace
##

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
fetch:
	git clone https://github.com/cymonsgames/ASCIIpOrtal.git
	cd ASCIIpOrtal
	git checkout v1.3-beta8
	git checkout -b v1.3-beta8-dirt

	# Note that the icon image used in AUR
	# IS NOT under a CC license and is a direct copy of Valve's copyrighted ascii art.
	# https://www.deviantart.com/dj-zemar/art/The-Official-Portal-ASCII-Art-176976417

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	@true

# Known as prepare 'patch' in ports.
prepare:
	cd ASCIIpOrtal && git apply "$(PACKAGE_DIR)/v1.3-beta8-dirt.patch"

# Configure the source codes build setup.
configure:
	@true

# Compile and otherwise package up for installation or distribution.
build:
	cd ASCIIpOrtal && make DESTDIR="$(PREFIX)" linux

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	cd ASCIIpOrtal && make DESTDIR="$(PREFIX)" install
	mkdir -p "$(PREFIX)/share/pixmaps/"
	install --mode=644 "$(PACKAGE_DIR)/asciiportal.png" "$(PREFIX)/share/pixmaps"
	mkdir -p "$(PREFIX)/share/applications"
	install --mode=644 "$(PACKAGE_DIR)/asciiportal.desktop" "$(PREFIX)/share/applications"

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

