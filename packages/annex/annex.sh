
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	# nsis is only needed if you build a Windows installer.
	echo "megaglest"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	git clone https://bitbucket.org/annexctw/annex
	# by default you'll be on the development branch, master is the most stable.
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

	#cd annex/mk_release/linux
	# makes a directory ../../../annex-release
	#./make-release.sh --dataonly

	# the above is really bundling everything into 7 zip file.
	return 0
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	local install_prefix="$1"

	#test -f ./annex-release/snapshot/annex-data.7z

	return 0
}

install () {
	# Install the package to the local system.
	local install_prefix="$1"
	
	# if you're using the 7 zip approach then you'll just have 
	# extract everything.

	# redick is just going to copy the files.
	# following the same convention as the Debian megaglest-data package.
	local data_dir="$install_prefix/usr/share/games/annex"
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

check_install () {
	# Any post install checks ands tests.
	local install_prefix="$1"
	megaglest --data-path="$install_prefix/usr/share/games/annex"
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
