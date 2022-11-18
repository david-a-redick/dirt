# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@echo 'possible copyright voliations with two music files.'
	@echo 'pending resolution'
	@false

# Install debian packages.
# sudo apt-get install ...
dependencies_debian:
	sudo apt-get python3-pygame

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
	wget https://launchpad.net/glamour/trunk/1.1/+download/glamour.tar.gz

# Perform any check sums or gpg signature verifications.
verify:
	sha512sum -c "$(PACKAGE_DIR)/glamour-1.1.sha512"

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	tar -xf glamour.tar.gz

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	@true

# Compile and otherwise package up for installation or distribution.
build:
	@true

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	@true

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

