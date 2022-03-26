#!/bin/sh

# Copyright 2020 - David A. Redick
#
# This file is part of dirt.
#
# dirt is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3 of the License.
#
# dirt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with dirt. If not, see <https://www.gnu.org/licenses/>. 

# shows the commands being executed
#set -x

DIRT_SCRIPT_FULL_PATH="$(realpath "$0")"
DIRT_LOCATION="$(dirname "${DIRT_SCRIPT_FULL_PATH}")"
DIRT_PACKAGES_PATH="${DIRT_LOCATION}/packages"
DIRT_SCRIPTS_PATH="${DIRT_LOCATION}/scripts"

. "${DIRT_LOCATION}/configuration.sh"
# Need to make sure these are full paths.
DIRT_WORKSPACE_PATH="$(realpath "$DIRT_WORKSPACE_PATH")"
DIRT_INSTALL_PATH="$(realpath "$DIRT_INSTALL_PATH")"
DIRT_HOOK_PATH="$(realpath "$DIRT_HOOK_PATH")"

usage () {
	local message='dirt.sh COMMAND PACKAGE_NAME'
	if [ 'err' = "$1" ]; then
		1>&2 echo "${message}"
	else
		echo "${message}"
	fi
}

help () {
	printf '
search NAME - Will search for any hits on the given NAME in both package files and group directories.

install PACKAGE_NAME - Will run through the all the stages from `check_local` to `check_install`

configure PACKAGE_NAME - Will only run the configure stage for the given package.

build PACKAGE_NAME - Will only run the build stage for the given package.

just_install PACKAGE_NAME - Will only run the install_package stage (nothing else)

hook PACKAGE_NAME - Will hook the package into use in the local environment (by default ~/.local).

unhook PACKAGE_NAME - Will remove all the file done by the `hook` command.

clean PACKAGE_NAME - Will unhook, delete the install and workspace directories of the package.
'
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

command_proot () {
	local package_name=$1

	local package_path="`get_package_path $package_name`"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name.  Try specific version."
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"
	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	proot \
	--rootfs="${DIRT_LOCATION}/dir-for-proot" \
	--bind="${package_dir}":/package \
	--bind="${workspace}":/workspace \
	--bind="${prefix}":"${DIRT_HOOK_PATH}" \
	--cwd=/ \
	--bind=/bin \
	--bind=/dev \
	--bind=/etc \
	--bind=/lib \
	--bind=/lib32 \
	--bind=/lib64 \
	--bind=/libx32 \
	--bind=/proc \
	--bind=/run \
	--bind=/sbin \
	--bind=/srv \
	--bind=/sys \
	--bind=/tmp \
	--bind=/usr \
	--bind=/var
}

command_search () {
	local package_name="$1"

	echo 'Package Groups:'
	find "$DIRT_PACKAGES_PATH" -type d -iname "*${package_name}*" -print

	echo '\nPackages:'
	find "$DIRT_PACKAGES_PATH" -type f -iname "*${package_name}*.make" -print
}

command_install () {
	local package_name=$1

	local package_path="`get_package_path $package_name`"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name.  Try specific version."
		exit 3
	fi

	# aka group_path
	local package_dir="`dirname "$package_path"`"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" check_local
	if [ 0 -ne $? ]; then
		1>&2 echo 'Your local system is not compatible.'
		exit 6
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" dependencies_debian

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" dependencies_dirt

	mkdir -p "${workspace}"
	cd "${workspace}"

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" fetch
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to fetch.'
		exit 7
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" verify
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to verify.'
		exit 8
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" extract
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to extract.'
		exit 9
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" prepare
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to prepare.'
		exit 10
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" configure
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to configure.'
		exit 11
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" build
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to build.'
		exit 12
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" test
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to test.'
		exit 13
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" install_package
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to install_package.'
		exit 14
	fi

	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" check_install
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to check_install.'
		exit 15
	fi
}

command_configure () {
	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"
	cd "${workspace}"

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	cd "${workspace}"
	PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" configure
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to configure.'
		exit 11
	fi
}

command_build () {
	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"

	. "$package_path"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"
	cd "${workspace}"

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	cd "${workspace}"
	build "${prefix}" "${package_dir}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to build.'
		exit 12
	fi
}

command_just_install () {
	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"

	. "$package_path"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	cd "${workspace}"
	install_package "${prefix}" "${package_dir}"
	if [ 0 -ne $? ]; then
		1>&2 echo 'Failed to install_package.'
		exit 14
	fi
}

command_hook () {
	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	cd "$prefix"
	cp -r * "$DIRT_HOOK_PATH"

	# we can't run it ourselves so let the user know
	echo "NOTE: bash users should run 'hash -r' to clear the command path cache."
}

command_unhook () {
	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local prefix="$DIRT_INSTALL_PATH/${package_name}"

	find "$prefix" -type f -exec "$DIRT_SCRIPTS_PATH/unhook.sh" file "$DIRT_INSTALL_PATH" "$DIRT_HOOK_PATH" ${package_name} \{\} \;

	find "$prefix" -type l -exec "$DIRT_SCRIPTS_PATH/unhook.sh" file "$DIRT_INSTALL_PATH" "$DIRT_HOOK_PATH" ${package_name} \{\} \;

	# note: this will hit on the prefix dir itself.
	# make sure we do depth first to clean child dirs before the parents
	# also, GNU find spits a warning if -depth comes after -type
	find "$prefix" -depth -type d -exec "$DIRT_SCRIPTS_PATH/unhook.sh" dir "$DIRT_INSTALL_PATH" "$DIRT_HOOK_PATH" ${package_name} \{\} \;

	# we can't run it ourselves so let the user know
	echo "NOTE: bash users should run 'hash -r' to clear the command path cache."
}

command_clean () {
	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"

	local installed_dir="${DIRT_INSTALL_PATH}/${package_name}"

	command_unhook $package_name

	rm -rf "$workspace"

	rm -rf "$installed_dir"
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

	# basically getting cdr from the substring ( $1='fooAbar' $2='A' then 'bar' ).
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

	local package_group=$(get_package_group $package_name)

	local package_path="${DIRT_PACKAGES_PATH}/${package_group}/${package_name}.make"

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
# This is not the gentoo category nor the debian section.
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
