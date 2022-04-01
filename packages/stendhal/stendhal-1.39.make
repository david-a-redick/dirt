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
	sudo apt-get install ant openjdk-11-jre

# Install dirt packages
dependencies_dirt:
	@true

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
fetch:
	wget https://sourceforge.net/projects/arianne/files/stendhal/1.39/stendhal-1.39-src.tar.gz/download

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	tar -xf stendhal-1.39-src.tar.gz

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	#cd stendhal-1.39
	@true

# Compile and otherwise package up for installation or distribution.
build:
	cd stendhal-1.39 && ant client_build

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	mkdir -p "${PREFIX}/bin"
	mkdir -p "${PREFIX}/libexec/stendhal"
	install 755 -T "${PACKAGE_DIR}/stendhal-1.39-client" "${PREFIX}/bin/stendhal"
	install 644 ./stendhal-1.39/build/lib/*.jar "${PREFIX}/libexec/stendhal"
	install 644 ./stendhal-1.39/lib/marauroa.jar "${PREFIX}/libexec/stendhal"
	install 644 ./stendhal-1.39/lib/log4j.jar "${PREFIX}/libexec/stendhal"
	install 644 ./stendhal-1.39/lib/jorbis.jar "${PREFIX}/libexec/stendhal"

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

