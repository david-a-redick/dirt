#!/bin/sh

# shows the commands being executed
#set -x

DIRT_SCRIPT_FULL_PATH=`realpath "$0"`
DIRT_LOCATION=`dirname "${DIRT_SCRIPT_FULL_PATH}"`
DIRT_PACKAGES_PATH="${DIRT_LOCATION}/packages"

. "${DIRT_LOCATION}/configuration.sh"
#echo $DIRT_WORKSPACE_PATH
#echo $DIRT_INSTALL_PATH

usage () {
	echo 'dirt.sh COMMAND PACKAGE'
}

help () {
	echo 'todo help'
}

main () {
	if [ '--help' = "$1" ]; then
		usage
		help
		exit 0
	elif [ 2 -ne $# ]; then
		usage
		exit 1
	fi

	to_run=$1
	package=$2

	# any function starting with 'command_' is consider to be availible from the cmd line
	target="command_${to_run}"
	is_function_defined $target
	if [ 0 -eq $? ]; then
		$target $package
	else
		echo "Unknown command ${to_run}"
		exit 2
	fi
}

is_function_defined () {
	function_name="$1"

	# use the builtin 'command' to look up the function name
	# in, what amounts to, the shell's symbol table and print it out.
	# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/command.html
	if [ "$(command -v ${function_name})" = "" ]; then
		#echo 'not there'
		return 1
	else
		#echo 'found it'
		return 0
	fi
}

command_install () {
	package_name=$1

	package_path="`get_package_path $package_name`"
	if [ 0 -ne $? ]; then
		echo "No dirt package $package_name"
		exit 3
	fi
	echo $package_path
	. "$package_path"

	check_local

	echo "Debian deps:" `list_dependencies_debian`

	echo "Dirt deps: " `list_dependencies_dirt`

	fetch

	verify

	extract

	patch

	configure

	build

	test

	install

	check_install
}

contains () {
	string="$1"
	substring="$2"

	# basically getting cdr from the substring ( $1=fooAbar $2=A then bar ).
	# If there are characters missing then we must have the substring in there.
	if [ "${string#*$substring}" != "$string" ]; then
		# in
		return 0
	else
		# not in
		return 1
	fi
}

# look up a single package
get_package_path () {
	package_name="$1"

	package_group=`get_package_group $package_name`

	package_path="${DIRT_PACKAGES_PATH}/${package_group}/${package_name}.sh"
	ls "$package_path" > /dev/null 2>&1
	if [ 0 -eq $? ]; then
		#echo 'found the package'
		echo $package_path
		return 0
	else
		#echo 'did not find package'
		echo ''
		return 1
	fi
}

# Given a correctly syntaxed package name (NAME-VERSION[-FEATURE]) return NAME.
# This is not the gentoo category.
get_package_group () {
	echo ${1%%-*}
}

command_search () {
	package_name="$1"

	echo 'Package Groups:'
	find "$DIRT_PACKAGES_PATH" -type d -iname "*${package_name}*" -print

	echo '\nPackages:'
	find "$DIRT_PACKAGES_PATH" -type f -iname "*${package_name}*.sh" -print
}

main $@
