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
	wget https://github.com/mogria/msnake/archive/refs/tags/v0.1.1.tar.gz

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	# creates a the directory msnake-0.1.1
	tar -xf v0.1.1.tar.gz

# Known as prepare 'patch' in ports.
prepare:
	# just remove the entire INSTALL line.
	# and add it back with the proper prefix
	cd msnake-0.1.1 && sed -i -e 's/^INSTALL.*//' CMakeLists.txt
	cd msnake-0.1.1 && echo 'INSTALL(TARGETS $${SNAKE_EXEC_NAME} DESTINATION $(PREFIX)/bin)' >> CMakeLists.txt

# Configure the source codes build setup.
# For some reason cmake needs to be called via full path
configure:
	cd msnake-0.1.1 && /usr/bin/cmake .

# Compile and otherwise package up for installation or distribution.
build:
	cd msnake-0.1.1 && make

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	cd msnake-0.1.1 && make install

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

