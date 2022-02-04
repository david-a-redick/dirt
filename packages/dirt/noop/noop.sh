# A package that does nothing but print out the various stages.

check_local () {
	# A sanity check of the local system.
	# Good place for things like CPU compatiblity, in case the application has inline assembler.
	echo 'check_local'
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
	echo 'fetch'
	return 0
}

verify () {
	# Perform any check sums or gpg signature verifications.
	echo 'verify'
	return 0
}

extract () {
	# In the cases of bundled release (zip, etc), this step will unpack the bundle.
	echo 'extract'
	return 0
}

patch () {
	# Known as prepare `prepare` in AUR.
	echo 'patch'
	return 0
}

configure () {
	# Configure the source codes build setup.
	echo 'configure'
	return 0
}

build () {
	# Compile and otherwise package up for installation or distribution.
	echo 'build'
	return 0
}

test () {
	# Run unit tests and perform compilation verification.
	# Known as `check` in AUR.
	echo 'test'
	return 0
}

install () {
	# Install the package to the local system.
	echo 'install'
	return 0
}

check_install () {
	# Any post install checks ands tests.
	echo 'check_install'
	return 0
}

purge () {
	# Remove any configuration (dot files) and other files created during run time.
	echo 'purge'
	return 0
}
