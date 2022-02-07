
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo "libgconf2-dev"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	wget https://download.gnome.org/sources/gconfmm/2.28/gconfmm-2.28.3.tar.xz
}

verify () {
	# Perform any check sums or gpg signature verifications.
	return 0
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	tar -xf gconfmm-2.28.3.tar.xz
	return 0
}

patch () {
	# Known as prepare `prepare` in AUR.
	return 0
}

configure () {
	# Configure the source codes build setup.
	local install_prefix="$1"
	cd gconfmm-2.28.3
	./configure --prefix="$install_prefix"
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	cd gconfmm-2.28.3
	make 
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
	cd gconfmm-2.28.3
	make install
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
