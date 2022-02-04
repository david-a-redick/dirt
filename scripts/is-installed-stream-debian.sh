#!/bin/sh

# shows the commands being executed
#set -x

usage () {
	message='is-installed-stream-debian.sh PKG_NAME_0 [PKG_NAME_1 ...]'
	if [ 'err' = "$1" ]; then
		1>&2 echo "${message}"
	else
		echo "${message}"
	fi
}

help () {
	printf '
Given a list of package names, determine if they are installed.

Installed packages will have their names written to stdout.

Packages not installed will have their names written to stderr.

If one of the given package names is not a package then a message will be
written to stderr and script will exit with return code of 2.

Examples:
If you have 7kaa lgeneral installed but do not have flare installed then:

# looking for packages that are installed
$ ./is-installed-stream-debian.sh 7kaa lgeneral flare 2> /dev/null
7kaa
lgeneral
$ echo $?
0

# looking for packages not installed.
$ ./is-installed-stream-debian.sh 7kaa lgeneral flare > /dev/null
flare
$ echo $?
0

# note that you will need to check for an error case.
$ ./is-installed-stream-debian.sh 7kaa lgeneral flare kjhlkj > /dev/null
flare
kjhlkj not a debian package.
$ echo $?
2

$ ./is-installed-stream-debian.sh 7kaa lgeneral flare kjhlkj 2> /dev/null
7kaa
lgeneral
$ echo $?
2

'
}

main () {
	# note: $# does not include $0
	if [ 0 -eq $# ]; then
		usage err
		exit 1
	elif [ '--help' = $1 ]; then
		usage
		help
		exit 0
	fi

	while [ $# -ge 1 ]; do
		package_name=$1
		is_a_package $package_name
		if [ 0 -eq $? ]; then
			is_installed $package_name
			if [ 0 -eq $? ]; then
				# installed
				echo "${package_name} "
			else
				# not installed
				1>&2 echo "${package_name} "
			fi
		else
			# some one give a bad package name.
			# bail out.
			exit 2
		fi
		shift
	done
}

# given a single package name, determine if its a real package name or just some letters
is_a_package () {
	apt-cache show $1 > /dev/null 2>&1
	return_code=$?
	if [ 0 -ne $return_code ]; then
		 1>&2 echo "$1 not a debian package."
	fi
	return $return_code
}

# given a single package name, is it installed?
is_installed () {
	dpkg-query --status $1 > /dev/null 2>&1
	return $?
}

main $@
