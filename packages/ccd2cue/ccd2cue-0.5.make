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
	@true

# Space delimited list of other dirt packages.
list_dependencies_dirt:
	@echo ''

##
# All of the following stages will be done in a proot environment.
# The real working directory will be: $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
# The proot working directory will be: /workspace
##

# Download the source code.
# Could be cloning the repo or could be a packaged release bundle (tar ball, etc).
fetch:
	wget https://ftpmirror.gnu.org/ccd2cue/ccd2cue-0.5.tar.gz

# Perform any check sums or gpg signature verifications.
verify:
	#gpg --verify ccd2cue-0.5.tar.gz.sig
	#gpg --recv-keys 0x28D618AF --keyserver hkp://keys.gnupg.net
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	tar -xf ccd2cue-0.5.tar.gz

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	cd ccd2cue-0.5 && ./configure --prefix=$(PREFIX)

# Compile and otherwise package up for installation or distribution.
build:
	cd ccd2cue-0.5 && make

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	cd ccd2cue-0.5 && make

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

