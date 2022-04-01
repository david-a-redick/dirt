# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

# The format version of this package.
schema:
	@echo '0'

check_local:
	@true

list_dependencies_debian:
	sudo apt-get install qttools5-dev-tools libqt5webkit5 libqt5webkit5-dev libqt5svg5 libqt5svg5-dev"

dependencies_dirt:
	@true

fetch:
	git clone https://github.com/notepadqq/notepadqq.git
	cd notepadqq &&	git checkout v1.4.8

verify:
	@true

extract:
	@true

prepare:
	@true

configure () {
	# Configure the source codes build setup.
	local install_prefix="$1"
	cd notepadqq
	./configure --prefix "${install_prefix}"
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	cd notepadqq
	make
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	local install_prefix="$1"
	return 0
}

install_package () {
	# Install the package to the local system.
	local install_prefix="$1"
	cd notepadqq
	make install
}

check_install:
	@true

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	echo 'todo ~/.config/Notepadqq/'
}
