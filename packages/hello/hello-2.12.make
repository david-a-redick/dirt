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
dependencies_debian:
	sudo apt-get install autopoint gperf texinfo help2man

# Install dirt packages
list_dependencies_dirt:
	@echo ''

fetch:
	# Working directory will be set to the package's working directory (scratch space)
	git clone https://git.savannah.gnu.org/git/hello.git
	cd hello && git checkout v2.12
	# this will fetch submodules and do some setup.
	cd hello && ./bootstrap

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	@true

# Known as prepare `patch` in ports.
prepare:
	@true

configure:
	cd hello && ./configure --prefix="$(PREFIX)"

build:
	cd hello && make

test:
	cd hello && make check

install_package:
	cd hello && make install

check_install:
	$(PREFIX)/bin/hello

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

