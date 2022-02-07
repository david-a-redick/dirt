#!/bin/sh

# Copyright 2020 - David A. Redick
#
# This file is part of dirt.
#
# dirt is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# dirt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with dirt. If not, see <https://www.gnu.org/licenses/>. 

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
	local install_prefix="$1"
	return 0
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	return 0
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
	return 0
}

check_install () {
	# Any post install checks ands tests.
	local install_prefix="$1"
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
'
