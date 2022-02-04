#!/bin/sh

usage () {
	echo 'dirt-debian.sh COMMAND PACKAGE'
}

help () {
	echo 'todo help'
}

main () {
	full_path=`realpath "$0"`
	location=`dirname "${FULL_PATH}"`
	packages_path="${location}/packages"
	. "${location}/configuration.sh"

	#echo $DIRT_WORKSPACE_PATH
	#echo $DIRT_INSTALL_PATH

	if [ '--help' = "$1" ]; then
		usage
		help
		exit 0
	elif [ 2 -ne $# ]; then
		usage
		exit 1
	fi

	command=$1
	package=$2

	# any function starting with 'command_' is consider to be availible from the cmd line
	command_$command "$packages_path" $package
}

command_install () {
	echo 'todo install'
}

contains () {
	string="$1"
	substring="$2"

	# basically get the rest of the string starting at the substring.
	# if there is characters missing then we must have the substring in there.
	if [ "${string#*$substring}" != "$string" ]; then
		# in
		return 0
	else
		# not in
		return 1
	fi
}

find_package () {
	packages_path=$1
	package_name=$2

	find "$packages_path" -iname $package_name -print
}

command_search () {
	packages_path="$1"
	package_name="$2"

	echo 'Package Groups:'
	find "$packages_path" -type d -iname "*$package_name*" -print

	echo '\nPackages:'
	find "$packages_path" -type f -iname "*$package_name*" -print
}

main $@
