
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo "qttools5-dev-tools libqt5webkit5 libqt5webkit5-dev libqt5svg5 libqt5svg5-dev"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	git clone https://github.com/notepadqq/notepadqq.git
	cd notepadqq
	git checkout v1.4.8
	true
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

	./configure --prefix "${install_prefix}"
}

build () {
	# Compile and otherwise package up for installation or distribution.
	local install_prefix="$1"
	make
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	local install_prefix="$1"
	return 0
}

install () {
	# Install the package to the local system.
	local install_prefix="$1"
	make install
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
