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
	message='dirt.sh COMMAND PACKAGE'
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

	to_run=$1
	package=$2

	# any function starting with 'command_' is consider to be availible from the cmd line
	target="command_${to_run}"
	is_function_defined $target
	if [ 0 -eq $? ]; then
		$target $package
	else
		1>&2 echo "Unknown command ${to_run}"
		exit 2
	fi
}

command_search () {
	package_name="$1"

	echo 'Package Groups:'
	find "$DIRT_PACKAGES_PATH" -type d -iname "*${package_name}*" -print

	echo '\nPackages:'
	find "$DIRT_PACKAGES_PATH" -type f -iname "*${package_name}*.sh" -print
}

command_install () {
	package_name=$1

	package_path="`get_package_path $package_name`"
	if [ 0 -ne $? ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi
	echo $package_path
	. "$package_path"

	check_local

	debian_deps=`list_dependencies_debian`
	need_to_install_debian $debian_deps

	echo "Dirt deps: " `list_dependencies_dirt`

	mkdir -p "${DIRT_WORKSPACE_PATH}/${package_name}"
	cd "$DIRT_WORKSPACE_PATH"

	#fetch

	#verify

	#extract

	#patch

	#configure

	#build

	#test

	#install

	#check_install
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

# given a list of (possible) debian packages
# determine if any need to be installed and if so stop and prompt user.
need_to_install_debian () {
	debian_need=
	while [ $# -ge 1 ]; do
		debian_package_name=$1
		is_a_debian_package $debian_package_name
		if [ 0 -eq $? ]; then
			is_debian_package_installed $debian_package_name
			if [ 0 -eq $? ]; then
				# installed
				#echo "YOU GOT ${debian_package_name}"
				true
			else
				# not installed
				 debian_need="${debian_need} ${debian_package_name}"
			fi
		else
			# some one give a bad package name.
			# bail out.
			1>&2 echo "The dirt package references an invalid Debian package: ${debian_package_name}"
			exit 4
		fi

		shift
	done

	if [ ! -z "$debian_need" ]; then
		echo 'You need to get some debian packages:'
		echo "apt-get install $debian_need"
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

main $@
