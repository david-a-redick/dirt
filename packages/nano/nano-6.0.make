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

dependencies_debian:
	# Install debian packages.
	sudo apt-get install libncurses-dev

list_dependencies_dirt:
	# Install dirt packages
	@echo ''

fetch:
	# Using a bundle here.  For hello we'll use their git repo.
	wget https://www.nano-editor.org/dist/v6/nano-6.0.tar.xz

verify:
	wget https://www.nano-editor.org/dist/v6/nano-6.0.tar.xz.asc
	echo 'todo'

extract:
	tar -xf nano-6.0.tar.xz

prepare:
	true

configure:
	cd nano-6.0 && ./configure --prefix="$(PREFIX)"

build:
	cd nano-6.0 && make

test:
	true

install_package:
	cd nano-6.0 && make install

check_install:
	"$(PREFIX)/bin/nano" --version

purge:
	echo 'in real life we should rm -rf $HOME/.nano'

