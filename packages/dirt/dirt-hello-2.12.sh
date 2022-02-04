
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
	echo "script is still in the WORKSPACE/dirt-hello-2.12/hello directory"
	pwd
	./configure --prefix="$install_prefix"
}

build () {
	install_prefix="$1"
	make
}

test () {
	install_prefix="$1"
	make check
}

install () {
	install_prefix="$1"
	make install
}

check_install () {
	install_prefix="$1"
	${install_prefix}/bin/hello
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	return 0
}
