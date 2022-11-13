# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@echo 'Note that the authors consider this to be an experimental library.'
	@echo 'They refuse to do any date or version tagging and do not recommend it for use.'
	@echo 'Each install may be completely different than the previous.'
	@echo 'This has been the case for the past 5 years.'
	@echo 'Hit enter to continue.'
	@read FOO

# Install debian packages.
# sudo apt-get install ...
dependencies_debian:
	sudo apt-get install libtool

# Install dirt packages
list_dependencies_dirt:
	@echo ''

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
fetch:
	git clone https://github.com/bitcoin-core/secp256k1.git

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
	cd secp256k1 && ./autogen.sh
	cd secp256k1 && ./configure --prefix="$(PREFIX)"

# Compile and otherwise package up for installation or distribution.
build:
	cd secp256k1 && make

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	cd secp256k1 && make check

# Install the package to the local system.
install_package:
	cd secp256k1 && make install

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true
