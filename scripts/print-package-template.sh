#!/bin/sh

printf '
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo ""
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	return 0
}

verify () {
	# Perform any check sums or gpg signature verifications.
	return 0
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	return 0
}

patch () {
	# Known as prepare `prepare` in AUR.
	return 0
}

configure () {
	# Configure the source codes build setup.
	install_prefix="$1"
	return 0
}

build () {
	# Compile and otherwise package up for installation or distribution.
	install_prefix="$1"
	return 0
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	install_prefix="$1"
	return 0
}

install () {
	# Install the package to the local system.
	install_prefix="$1"
	return 0
}

check_install () {
	# Any post install checks ands tests.
	install_prefix="$1"
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
'
