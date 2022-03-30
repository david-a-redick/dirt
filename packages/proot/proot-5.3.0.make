# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@true

# Install debian packages.
dependencies_debian:
	sudo apt-get install libtalloc-dev libarchive-dev uthash-dev

# Install dirt packages
dependencies_dirt:
	@true

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
fetch:
	wget https://github.com/proot-me/proot/archive/refs/tags/v5.3.0.tar.gz

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	tar -xf v5.3.0.tar.gz

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	@true

# Compile and otherwise package up for installation or distribution.
# first build the config and loader
# then compile PRoot and CARE
build:
	cd proot-5.3.0 && make -C src loader.elf loader-m32.elf build.h
	cd proot-5.3.0 && make -C src proot care

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	cd proot-5.3.0 && make -C test

# Install the package to the local system.
install_package:
	@true

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

