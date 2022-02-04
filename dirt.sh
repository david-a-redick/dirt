#!/bin/sh

# shows the commands being executed
#set -x

DIRT_SCRIPT_FULL_PATH="`realpath "$0"`"
DIRT_LOCATION="`dirname "${DIRT_SCRIPT_FULL_PATH}"`"
DIRT_PACKAGES_PATH="${DIRT_LOCATION}/packages"

. "${DIRT_LOCATION}/configuration.sh"
# Need to make sure these are full paths.
DIRT_WORKSPACE_PATH="`realpath "$DIRT_WORKSPACE_PATH"`"
DIRT_INSTALL_PATH="`realpath "$DIRT_INSTALL_PATH"`"

usage () {
	local message='dirt.sh COMMAND PACKAGE'
	if [ 'err' = "$1" ]; then
		1>&2 echo "${message}"
	else
		echo "${message}"
	fi
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
		usage err
		exit 1
	fi

	local to_run=$1
	local package=$2

	# any function starting with 'command_' is consider to be availible from the cmd line
	local target="command_${to_run}"
	is_function_defined $target
	if [ 0 -eq $? ]; then
		$target $package
	else
		1>&2 echo "Unknown command ${to_run}"
		exit 2
	fi
}

command_search () {
	local package_name="$1"

	echo 'Package Groups:'
	find "$DIRT_PACKAGES_PATH" -type d -iname "*${package_name}*" -print

	echo '\nPackages:'
	find "$DIRT_PACKAGES_PATH" -type f -iname "*${package_name}*.sh" -print
}

command_install () {
	local package_name=$1

	local package_path="`get_package_path $package_name`"
	if [ 0 -ne $? ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	. "$package_path"

	check_local
	if [ 0 -ne $? ]; then
		1>&2 echo 'Your local system is not compatible.'
		exit 6
	fi

	need_to_install debian `list_dependencies_debian`

	need_to_install dirt `list_dependencies_dirt`

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"
	cd "${workspace}"

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	fetch
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to fetch.'
		exit 7
	fi

	verify
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to verify.'
		exit 8
	fi

	extract
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to extract.'
		exit 9
	fi

	patch
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to patch.'
		exit 10
	fi

	configure "${prefix}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to configure.'
		exit 11
	fi

	build "${prefix}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to build.'
		exit 12
	fi

	test "${prefix}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to test.'
		exit 13
	fi

	install "${prefix}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to install.'
		exit 14
	fi

	check_install "${prefix}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to check_install.'
		exit 15
	fi
}

is_function_defined () {
	local function_name="$1"

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

contains () {
	local string="$1"
	local substring="$2"

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
	local package_name="$1"

	local package_group=`get_package_group $package_name`

	local package_path="${DIRT_PACKAGES_PATH}/${package_group}/${package_name}.sh"
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

# given a list of (possible) debian/dirt packages
# determine if any need to be installed and if so stop and prompt user.
# first arg must be 'debian' or 'dirt'
# which will use the appropriate functions:
# 	is_a_${system}_package
#	is_${system}_package_installed
need_to_install () {
	local system=$1
	shift

	local need=
	while [ $# -ge 1 ]; do
		local package_name=$1
		is_a_${system}_package $package_name
		if [ 0 -eq $? ]; then
			is_${system}_package_installed $package_name
			if [ 0 -eq $? ]; then
				# installed
				#echo "YOU GOT ${package_name}"
				true
			else
				# not installed
				need="${need} ${package_name}"
			fi
		else
			# some one give a bad package name.
			# bail out.
			1>&2 echo "The dirt package references an invalid ${system} package: ${package_name}"
			exit 4
		fi

		shift
	done

	if [ ! -z "$need" ]; then
		echo "You need to get some ${system} packages:"
		echo "$need"
		exit 5
	fi
}

# given a single package name, determine if its a real package name or just some letters
is_a_debian_package () {
	apt-cache show $1 > /dev/null 2>&1
	return $?
}

# given a single package name, is it installed?
is_debian_package_installed () {
	dpkg-query --status $1 > /dev/null 2>&1
	return $?
}

# given a single package name, determine if its a real package name or just some letters
is_a_dirt_package () {
	local package_path="`get_package_path $1`"
	return $?
}

# given a single package name, is it installed?
is_dirt_package_installed () {
	ls "${DIRT_INSTALL_PATH}/${1}" > /dev/null 2>&1
	return $?
}

main $@
