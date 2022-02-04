
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo "autopoint"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	git clone https://git.savannah.gnu.org/git/hello.git
	cd hello
	git checkout v2.12
	# this will fetch submodules and do some setup.
	./bootstrap
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
	install_prefix="$1"
	echo 'we should still be in the same spot'
	ls -l
	./configure --prefix="$install_prefix"
	return 0
}

build () {
	install_prefix="$1"
	# Compile and otherwise package up for installation or distribution.
	return 0
}

test () {
	install_prefix="$1"
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	return 0
}

install () {
	install_prefix="$1"
	# Install the package to the local system.
	return 0
}

check_install () {
	install_prefix="$1"
	# Any post install checks ands tests.
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
