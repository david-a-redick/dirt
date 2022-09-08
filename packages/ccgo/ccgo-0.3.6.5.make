# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

# A sanity check of the local system.
# Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local:
	@echo "Cant figure out how to find local gconfmm"
	@false

dependencies_debian:
	sudo apt-get install libgtkmm-2.4-dev

# List dirt packages
list_dependencies_dirt:
	@echo 'gconfmm-2.28.3'

fetch:
	wget https://ccdw.org/~cjj/prog/ccgo/src/ccgo-0.3.6.5.tar.gz

verify:
	@true

extract:
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	tar -xf ccgo-0.3.6.5.tar.gz

prepare:
	@true

configure:
	# Configure the source codes build setup.
	cd ccgo-0.3.6.5 && ./configure --prefix="$(PREFIX)"

build:
	# Compile and otherwise package up for installation or distribution.
	cd ccgo-0.3.6.5 && make

test:
	@true

install_package:
	@true

check_install:
	@true

purge:
	@true

