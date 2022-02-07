check_local () {
	return 0
}

list_dependencies_debian () {
	echo 'libncurses-dev'
}

list_dependencies_dirt () {
	echo ''
}

fetch () {
	# Using a bundle here.  For hello we'll use their git repo.
	wget https://www.nano-editor.org/dist/v6/nano-6.0.tar.xz
}

verify () {
	wget https://www.nano-editor.org/dist/v6/nano-6.0.tar.xz.asc
	echo 'todo'
}

extract () {
	tar -xf nano-6.0.tar.xz
}

prepare () {
	# Known as prepare `patch` in ports.
	return 0
}

configure () {
	local install_prefix="$1"
	cd nano-6.0
	./configure --prefix="${install_prefix}"
}

build () {
	local install_prefix="$1"
	cd nano-6.0
	make
}

test () {
	return 0
}

install_package () {
	local install_prefix="$1"
	cd nano-6.0
	make install
}

check_install () {
	local install_prefix="$1"
	"$install_prefix/bin/nano" --version
}

purge () {
	echo 'in real life we should rm -rf $HOME/.nano'
}
