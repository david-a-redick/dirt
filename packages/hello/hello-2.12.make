# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

check_local:
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	true

dependencies_debian:
	# Install debian packages.
	sudo apt-get install autopoint gperf texinfo help2man

dependencies_dirt:
	# Install dirt packages
	true

fetch:
	# Working directory will be set to the package's working directory (scratch space)
	git clone https://git.savannah.gnu.org/git/hello.git
	cd hello && git checkout v2.12
	# this will fetch submodules and do some setup.
	cd hello && ./bootstrap

verify:
	# Perform any check sums or gpg signature verifications.
	true


extract:
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	true

prepare:
	# Known as prepare `patch` in ports.
	true

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

purge:
	# Remove any configuration (dot files) and other files created during run time.
	true

