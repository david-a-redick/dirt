# A package that does nothing but fail at the local sanity check.

check_local () {
	local distro_name=`lsb_release -s -i`
	if [ "Debian" = $distro_name ]; then
		echo 'You have Debian.'
		return 1
	else
		echo 'This is not Debian.'
		return 1
	fi
}

list_dependencies_debian () {
	echo 'should not reach here'
	exit 6
}

list_dependencies_dirt () {
	echo 'should not reach here'
	exit 6
}

fetch () {
	echo 'should not reach here'
	exit 6
}

verify () {
	echo 'should not reach here'
	exit 6
}

extract () {
	echo 'should not reach here'
	exit 6
}

patch () {
	echo 'should not reach here'
	exit 6
}

configure () {
	echo 'should not reach here'
	exit 6
}

build () {
	echo 'should not reach here'
	exit 6
}

test () {
	echo 'should not reach here'
	exit 6
}

install_package () {
	echo 'should not reach here'
	exit 6
}

check_install () {
	echo 'should not reach here'
	exit 6
}

purge () {
	echo 'should not reach here'
	exit 6
}
