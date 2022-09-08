# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

check_local:
	@true

# Install debian packages.
# sudo apt-get install ...
dependencies_debian:
	sudo apt-get install libsdl1.2-dev libsdl-image1.2-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev fonts-averia-sans-gwf

# Space delimited list of other dirt packages.
dependencies_dirt:
	@echo 'beret-data-1.2.2'

fetch:
	# gitorious is all but dead and the cert has expired.
	#GIT_SSL_NO_VERIFY=true git clone https://gitorious.org/beret/beret.git
	git clone https://github.com/david-a-redick/beret.git

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
	@true


# Compile and otherwise package up for installation or distribution.
build:
	cd beret && PREFIX="$(PREFIX)" PATH_TO_DATA="$(PREFIX)/share/games/beret" make

# Run unit tests and perform compilation verification.
# Known as 'check' in AUR.
test:
	@true

# Install the package to the local system.
install_package:
	cd beret && PREFIX="$(PREFIX)" make install

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

