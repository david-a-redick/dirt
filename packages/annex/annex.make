# These will be defined with proper values at dirt.sh run time.
PREFIX ?= 'the directory to install the package'
PACKAGE_DIR ?= 'the directory (group) that the package is in - may contain signatures, checksums or patches'

check_local:
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	true

list_dependencies_debian:
	# Install debian packages.
	# nsis is only needed if you build a Windows installer.
	sudo apt-get install megaglest

list_dependencies_dirt:
	# Install dirt packages
	true

fetch:
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	git clone https://bitbucket.org/annexctw/annex
	# by default you'll be on the development branch, master is the most stable.

verify:
	# Perform any check sums or gpg signature verifications.
	true

extract:
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	true

prepare:
	# Known as prepare `patch` in ports.
	true

configure:
	# Configure the source codes build setup.
	true

build:
	# Compile and otherwise package up for installation or distribution.

	#cd annex/mk_release/linux
	# makes a directory ../../../annex-release
	#./make-release.sh --dataonly

	# the above is really bundling everything into 7 zip file.
	true

test:
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.

	#test -f ./annex-release/snapshot/annex-data.7z
	true

install_package:
	# Install the package to the local system.

	# if you're using the 7 zip approach then you'll just have
	# extract everything.

	# redick is just going to copy the files.
	# following the same convention as the Debian megaglest-data package.
	data_dir="$(PREFIX)/share/games/annex"
	mkdir -p "$data_dir"

	cd annex

	cp -r servers.ini \
	glestkeys.ini \
	editor.ico \
	data \
	docs \
	manual \
	maps \
	scenarios \
	techs \
	tilesets \
	"$data_dir"
}

check_install:
	# Any post install checks ands tests.
	megaglest --data-path="$(PREFIX)/share/games/annex"

purge:
	# Remove any configuration (dot files) and other files created during run time.
	true

