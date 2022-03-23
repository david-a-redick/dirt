
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	local install_prefix="$1"
	local package_dir="$2"
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
	local install_prefix="$1"
	local package_dir="$2"
	wget https://github.com/Andrettin/Wyrmsun/archive/refs/tags/v5.3.4.tar.gz -O Wyrmsun_5.3.4-1.orig.tar.gz
}

verify () {
	# Perform any check sums or gpg signature verifications.
	local install_prefix="$1"
	local package_dir="$2"
	sha512sum -c "${package_dir}/Wyrmsun-5.3.4.sha512"
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	local install_prefix="$1"
	local package_dir="$2"
	tar -xf Wyrmsun_5.3.4-1.orig.tar.gz
}

prepare () {
	# Known as prepare `patch` in ports.
	local install_prefix="$1"
	local package_dir="$2"
	return 0
}

configure () {
	# Configure the source codes build setup.
	local install_prefix="$1"
	local package_dir="$2"
	return 0
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	local package_dir="$2"
	return 0
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	local install_prefix="$1"
	local package_dir="$2"
	return 0
}

install_package () {
	# Install the package to the local system.
	local install_prefix="$1"
	local package_dir="$2"
	return 0
}

check_install () {
	# Any post install checks ands tests.
	local install_prefix="$1"
	local package_dir="$2"
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
