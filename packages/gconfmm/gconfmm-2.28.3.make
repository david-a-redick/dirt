# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@true

dependencies_debian:
	sudo apt-get install libgconf2-dev

# Space delimited list of other dirt packages.
dependencies_dirt:
	@true

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
fetch:
	wget https://download.gnome.org/sources/gconfmm/2.28/gconfmm-2.28.3.tar.xz

verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	tar -xf gconfmm-2.28.3.tar.xz

# Known as prepare 'patch' in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	cd gconfmm-2.28.3 && ./configure --prefix="$(PREFIX)"

# Compile and otherwise package up for installation or distribution.
build:
	cd gconfmm-2.28.3 && make
	cd gconfmm-2.28.3/gconf && sed -i -e "s/$(PREFIX)/bob/" gconfmm-2.6.pc

test:
	@true

# Install the package to the local system.
install_package:
	cd gconfmm-2.28.3 && make install

# Any post install checks ands tests.
check_install:
	@true

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true
