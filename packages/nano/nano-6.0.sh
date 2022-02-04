# Intended as an example as debian usually provides this in the base install.

# A sanity check of the local system.  Good place for things like CPU compatiblity, in case the application has inline assembler.
check_local () {
	# In real life, this should just return 0.
	# but provides a nice example.

}

# Space delimited list of debian packages.
list_dependencies_debian () {
	echo 'libncurses-dev'
}

list_dependencies_dirt () {
	""
}

# Download the source code.  Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).
fetch () {
	# Using a bundle here.  For hello we'll use their git repo.
	wget https://www.nano-editor.org/dist/v6/nano-6.0.tar.xz
}

# Perform any check sums or gpg signature verifications.
verify () { 
	wget https://www.nano-editor.org/dist/v6/nano-6.0.tar.xz.asc
}

# In the cases of bundled release (zip, etc), this step will unpack the bundle.
extract () {
	tar -xf nano-6.0.tar.xz
}

# Known as prepare `prepare` in AUR.
patch () {
	echo 'nothing to patch'
}

# Configure the source code's build setup.
configure () {
	echo 'todo'
}

# Compile and otherwise package up for installation or distribution.
build () {
	echo 'todo'
}

# Run unit tests and perform compilation verification.  Known as `check` in AUR.
test () {
	echo 'todo'
} 

# Install the package to the local system.
install () {
	echo 'todo'
}

# Any post install checks ands tests.
check_install () {
	echo 'todo'
}

# Remove any configuration (dot files) and other files created during run time.
purge () {
	echo 'in real life we should rm -rf $HOME/.nano'
}
