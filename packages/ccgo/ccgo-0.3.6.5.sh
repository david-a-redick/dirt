
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	echo "Cant figure out how to find local gconfmm"
	return 1
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo "libgtkmm-2.4-dev"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo "gconfmm-2.28.3"
}

fetch () {
	# Download the source code.
	# Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
	# The working directory will be $DIRT_WORKSPACE_PATH/$PACKAGE_NAME/
	wget https://ccdw.org/~cjj/prog/ccgo/src/ccgo-0.3.6.5.tar.gz
}

verify () {
	# Perform any check sums or gpg signature verifications.
	return 0
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	tar -xf ccgo-0.3.6.5.tar.gz
}

patch () {
	# Known as prepare `prepare` in AUR.
	return 0
}

configure () {
	# Configure the source codes build setup.
	local install_prefix="$1"
	cd ccgo-0.3.6.5
	./configure --prefix="$install_prefix"
}

build () {
	# Compile and otherwise package up for installation or distribution.
	cd ccgo-0.3.6.5
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
