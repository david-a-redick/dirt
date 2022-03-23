
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo "libyaml-cpp-dev libsdl1.2-dev libsdl-mixer1.2-dev"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo "pdcurses-3.9"
}

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	git clone https://github.com/cymonsgames/ASCIIpOrtal.git
	cd ASCIIpOrtal
	git checkout v1.3-beta8
	git checkout -b v1.3-beta8-dirt

	# Note that the icon image used in AUR.
	# IS NOT under a CC license and is a direct copy of Valve's copyrighted ascii art.
	# https://www.deviantart.com/dj-zemar/art/The-Official-Portal-ASCII-Art-176976417
}

verify () {
	# Perform any check sums or gpg signature verifications.
	return 0
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	return 0
}

prepare () {
	# Known as prepare `patch` in ports.
	local install_prefix="$1"
	local package_dir="$2"
	cd ASCIIpOrtal
	git apply "${package_dir}/v1.3-beta8-dirt.patch"
}

configure () {
	# Configure the source codes build setup.
	local install_prefix="$1"
	return 0
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	cd ASCIIpOrtal
	# compile with includes and libraries and runtime shared resources
	# under $HOME/.local or where ever
	make DESTDIR="$DIRT_HOOK_PATH" linux
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
	local package_dir="$2"

	cd ASCIIpOrtal
	make DESTDIR="$install_prefix" install

	mkdir -p "$install_prefix/share/pixmaps/"
	install --mode=644 "${package_dir}/asciiportal.png" "$install_prefix/share/pixmaps"

	mkdir -p "$install_prefix/share/applications"
	install --mode=644 "${package_dir}/asciiportal.desktop" "$install_prefix/share/applications"
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
