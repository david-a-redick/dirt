#!/bin/sh

# Copyright 2020 - David A. Redick
#
# This file is part of dirt.
#
# dirt is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License.
#
# dirt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with dirt. If not, see <https://www.gnu.org/licenses/>. 

echo "# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

check_local:
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	true

dependencies_debian:
	# Install debian packages.
	# sudo apt-get install ...
	true

dependencies_dirt:
	# Install dirt packages
	true

fetch:
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be \$DIRT_WORKSPACE_PATH/\$PACKAGE_NAME/
	true

verify:
	# Perform any check sums or gpg signature verifications.
	true

extract:
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	true

prepare:
	# Known as prepare 'patch' in ports.
	true

configure:
	# Configure the source codes build setup.
	true

build:
	# Compile and otherwise package up for installation or distribution.
	true

test:
	# Run unit tests and perform compilation verification.
	# Known as 'check' in AUR.
	true

install_package:
	# Install the package to the local system.
	true

check_install:
	# Any post install checks ands tests.
	true

purge:
	# Remove any configuration (dot files) and other files created during run time.
	true
"
