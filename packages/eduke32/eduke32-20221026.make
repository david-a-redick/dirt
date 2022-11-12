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
	sudo apt-get install libvpx-dev libvpx6

# Space delimited list of other dirt packages.
list_dependencies_dirt:
	@echo ''

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
fetch:
	wget https://dukeworld.com/eduke32/synthesis/latest/eduke32_src_20221026-10165-a9c797dcb.tar.xz


# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	tar -xf eduke32_src_20221026-10165-a9c797dcb.tar.xz

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	cd eduke32_20221026-10165-a9c797dcb

# Compile and otherwise package up for installation or distribution.
build:
	make -f GNUmakefile

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	mkdir -p $(PREFIX)/bin
	install eduke32_20221026-10165-a9c797dcb/eduke32 $(PREFIX)/bin/eduke32
	install eduke32_20221026-10165-a9c797dcb/mapster32 $(PREFIX)/bin/mapster32

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

