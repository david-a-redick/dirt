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

# Install debian packages.
# nsis is only needed if you build a Windows installer.
dependencies_debian:
	sudo apt-get install megaglest

# Space delimited list of other dirt packages.
dependencies_dirt:
	@echo ''

# Download the source code.
# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
# by default you'll be on the development branch, master is the most stable.
fetch:
	git clone https://bitbucket.org/annexctw/annex

# Perform any check sums or gpg signature verifications.
verify:
	@true

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract:
	@true

# Known as prepare `patch` in ports.
prepare:
	@true

# Configure the source codes build setup.
configure:
	@true

build:
	# Compile and otherwise package up for installation or distribution.

	#cd annex/mk_release/linux
	# makes a directory ../../../annex-release
	#./make-release.sh --dataonly

	# the above is really bundling everything into 7 zip file.
	@true

test:
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.

	#test -f ./annex-release/snapshot/annex-data.7z
	@true

install_package:
	# Install the package to the local system.

	# if you're using the 7 zip approach then you'll just have
	# extract everything.

	# redick is just going to copy the files.
	# following the same convention as the Debian megaglest-data package.
	mkdir -p "$(PREFIX)/share/games/annex"

	cd annex && \
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
	"$(PREFIX)/share/games/annex"

check_install:
	# Any post install checks ands tests.
	megaglest --data-path="$(PREFIX)/share/games/annex"

# Remove any configuration (dot files) and other files created during run time.
purge:
	@true

