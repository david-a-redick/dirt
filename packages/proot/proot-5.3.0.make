# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@echo 'compiles but the tests fail and hard hang in proot-5.1.0'
	@false

# Install debian packages.
dependencies_debian:
	sudo apt-get install libtalloc-dev libarchive-dev uthash-dev

list_dependencies_dirt:
	@echo ''

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
	cd proot-5.3.0 && PREFIX=$(PREFIX) make -C src loader.elf loader-m32.elf build.h
	cd proot-5.3.0 && PREFIX=$(PREFIX) make -C src proot care

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
# NOTE: Some tests fail.
test:
	cd proot-5.3.0 && PREFIX=$(PREFIX) make -C test

# Install the package to the local system.
# NOTE: That the proot's install is very silent.
install_package:
	cd proot-5.3.0 && PREFIX=$(PREFIX) make -C src install

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

