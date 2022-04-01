# A do nothing package.

# The format version of this package.
schema:
	@echo '0'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@echo 'check_local'

# Install debian packages.
# sudo apt-get install ...
dependencies_debian:
	@echo 'dependencies_debian'

# Install dirt packages
dependencies_dirt:
	@echo 'dependencies_dirt'

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
fetch:
	@echo 'fetch'

# Perform any check sums or gpg signature verifications.
verify:
	@echo 'verify'

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	@echo 'extract'

# Known as prepare 'patch' in ports.
prepare:
	@echo 'prepare'

# Configure the source codes build setup.
configure:
	@echo 'configure'

# Compile and otherwise package up for installation or distribution.
build:
	@echo 'build'

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@echo 'test'

# Install the package to the local system.
install_package:
	@echo 'install_package'

# Any post install checks ands tests.
check_install:
	@echo 'check_install'

# Remove any configuration (dot files) and other files created during run time.
purge:
	@echo 'purge'

