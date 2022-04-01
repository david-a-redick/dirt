# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

check_local:
	@echo 'possible copyright voliations with two music files.'
	@echo 'pending resolution'
	@false

dependencies_debian:
	sudo apt-get python3-pygame

dependencies_dirt:
	@true

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	wget https://launchpad.net/glamour/trunk/1.1/+download/glamour.tar.gz
}

verify () {
	# Perform any check sums or gpg signature verifications.
	local install_prefix="$1"
	local package_dir="$2"
	sha512sum -c "${package_dir}/glamour-1.1.sha512"
}

extract:
	tar -xf glamour.tar.gz

prepare:
	@true

configure:
	@true

build:
	@true

test:
	@true

install_package:
	@true

check_install:
	@true

purge:
	@true
