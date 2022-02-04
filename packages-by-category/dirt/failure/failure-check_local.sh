# A package that does nothing but fail at the local sanity check.

check_local () {
	echo 'fail check_local'
	return 1
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

install () {
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
