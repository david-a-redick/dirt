
check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	return 0
}

list_dependencies_debian () {
	# Space delimited list of debian packages.
	echo "autopoint gperf texinfo help2man"
}

list_dependencies_dirt () {
	# Space delimited list of other dirt packages.
	echo ""
}

fetch () {
	git clone https://git.savannah.gnu.org/git/hello.git

	cd hello
	# script will reset to WORKSPACE (the ..) at each stage.

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
	local install_prefix="$1"
	cd hello
	./configure --prefix="$install_prefix"
}

build () {
	local install_prefix="$1"
	cd hello
	make
}

test () {
	local install_prefix="$1"
	cd hello
	make check
}

install () {
	local install_prefix="$1"
	cd hello
	make install
}

check_install () {
	local install_prefix="$1"
	${install_prefix}/bin/hello
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
