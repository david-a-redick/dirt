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

# if DIRT_DEBUG is set (to any value) then show the commands being executed
# and print to stderr ">>>FUNCTION_NAME $@" at function entry.
# You can set this via command line at exec time.
# $ DIRT_DEBUG=1 ./dirt.sh CMD PGK
if [ "$DIRT_DEBUG" ]; then
	export DIRT_DEBUG
	# print commands with prefix '+'
	set -x
fi


DIRT_SCRIPT_FULL_PATH="$(realpath "$0")"
DIRT_LOCATION="$(dirname "${DIRT_SCRIPT_FULL_PATH}")"
DIRT_PACKAGES_PATH="${DIRT_LOCATION}/packages"
DIRT_SCRIPTS_PATH="${DIRT_LOCATION}/scripts"

. "${DIRT_LOCATION}/configuration.sh"
# Need to make sure these are full paths.
DIRT_WORKSPACE_PATH="$(realpath "$DIRT_WORKSPACE_PATH")"
DIRT_INSTALL_PATH="$(realpath "$DIRT_INSTALL_PATH")"
# the run_stages.sh needs this to be exported.
export DIRT_HOOK_PATH="$(realpath "$DIRT_HOOK_PATH")"

usage () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>usage $@"
	fi

	local message='dirt.sh COMMAND PACKAGE_NAME'
	if [ -n "$2" ]; then
		message=$2
	fi

	if [ 'err' = "$1" ]; then
		1>&2 echo "${message}"
	else
		echo "${message}"
	fi
}

help () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>help $@"
	fi

	printf '
search NAME - Will search for any hits on the given NAME in both package files and group directories.

install PACKAGE_NAME - Will run through the all the stages from `check_local` to `check_install`

stage PACKAGE_NAME STAGE_NAME - Will only run the given stage for the given package.

sandbox PACKAGE_NAME - Will create a sandbox environment and create a shell for you to explore.

hook PACKAGE_NAME - Will hook the package into use in the local environment (by default ~/.local).

unhook PACKAGE_NAME - Will remove all the file done by the `hook` command.

clean PACKAGE_NAME - Will unhook, delete the install and workspace directories of the package.
'
}

main () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>main $@"
	fi

	if [ '--help' = "$1" ]; then
		usage
		help
		exit 0
	elif [ 'stage' = "$1" ] && [ 3 -ne $# ]; then
		usage err 'dirt.sh stage PACKAGE_NAME STAGE_NAME'
		exit 1
	elif [ 'stage' != "$1" ] && [ 2 -ne $# ]; then
		usage err
		exit 1
	fi

	local to_run=$1
	local package=$2
	local stage=$3

	# any function starting with 'command_' is consider to be availible from the cmd line
	local target="command_${to_run}"
	is_function_defined $target
	if [ 0 -eq $? ]; then
		$target $package $stage
	else
		1>&2 echo "Unknown command ${to_run}"
		exit 2
	fi
}

command_sandbox () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_sandbox $@"
	fi

	local package_name=$1
	run_proot $package_name "/bin/bash"
}

# Not complete.
run_fakechroot () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>run_fakechroot $@"
	fi

	local package_name=$1
	# the shell command to run when we drop into fakechroot. (optional)
	local shell_command=$2

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name.  Try specific version."
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"

	local prefix="${DIRT_INSTALL_PATH}/${package_name}"
	mkdir -p "${prefix}"


	mkdir -p "${DIRT_HOOK_PATH}"

	# TODO
}

run_proot () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>run_proot $@"
	fi

	local package_name=$1
	# the shell command to run when we drop into proot. (optional)
	local shell_command=$2

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name.  Try specific version."
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"

	local prefix="${DIRT_INSTALL_PATH}/${package_name}"
	mkdir -p "${prefix}"


	mkdir -p "${DIRT_HOOK_PATH}"

	proot \
	--rootfs="${DIRT_LOCATION}/dir-for-sandbox" \
	--bind="${package_dir}":/package \
	--bind="${workspace}":/workspace \
	--bind="${prefix}":"${DIRT_HOOK_PATH}" \
	--bind="${DIRT_LOCATION}/scripts":/scripts \
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
	--bind=/var \
	$shell_command
}

command_search () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_search $@"
	fi

	local package_name="$1"

	echo 'Package Groups:'
	find "$DIRT_PACKAGES_PATH" -type d -iname "*${package_name}*" -print

	echo '\nPackages:'
	find "$DIRT_PACKAGES_PATH" -type f -iname "*${package_name}*.make" -print
}

command_install () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_install $@"
	fi

	local package_name=$1

	run_stages $package_name 'check_local' 'dependencies_debian' 'dependencies_dirt'
	run_proot $package_name "/scripts/run_stages.sh ${package_name}"
}

command_stage () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_stage $@"
	fi

	local package_name=$1
	local stage=$2

	if [ 'check_local' = "$stage" ] || [ 'dependencies_debian' = "$stage" ] || [ 'dependencies_dirt' = "$stage" ]; then
		run_stages $package_name $stage
	else
		run_proot $package_name "/scripts/run_stages.sh ${package_name} ${stage}"
	fi
}

command_hook () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_hook $@"
	fi

	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local prefix="${DIRT_INSTALL_PATH}/${package_name}"

	cd "$prefix"
	cp -r * "$DIRT_HOOK_PATH"

	# we can't run it ourselves so let the user know
	echo "NOTE: bash users should run 'hash -r' to clear the command path cache."
}

command_unhook () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_unhook $@"
	fi

	local package_name=$1

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local prefix="${DIRT_INSTALL_PATH}/${package_name}"

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
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>command_clean $@"
	fi

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
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>is_function_defined $@"
	fi

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
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>contains $@"
	fi

	local string="$1"
	local substring="$2"

	# basically getting cdr from the substring ( $1='fooAbar' $2='A' then 'bar' ).
	# If there are characters missing then we must have the substring in there.
	#
	# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
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
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>get_package_path $@"
	fi

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
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>get_package_group $@"
	fi

	echo ${1%%-*}
}

# given a list of (possible) debian/dirt packages
# determine if any need to be installed and if so stop and prompt user.
# first arg must be 'debian' or 'dirt'
# which will use the appropriate functions:
# 	is_a_${system}_package
#	is_${system}_package_installed
need_to_install () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>need_to_install $@"
	fi

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
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>is_a_debian_package $@"
	fi

	apt-cache show $1 > /dev/null 2>&1
	return $?
}

# given a single package name, is it installed?
is_debian_package_installed () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>is_debian_package_installed $@"
	fi

	dpkg-query --status $1 > /dev/null 2>&1
	return $?
}

# given a single package name, determine if its a real package name or just some letters
is_a_dirt_package () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>is_a_dirt_package $@"
	fi

	local package_path="$(get_package_path $1)"
	return $?
}

# given a single package name, is it installed?
is_dirt_package_installed () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>is_dirt_package_installed $@"
	fi

	ls "${DIRT_INSTALL_PATH}/${1}" > /dev/null 2>&1
	return $?
}

# runs stages outside of proot
run_stages () {
	if [ "$DIRT_DEBUG" ]; then
		1>&2 echo ">>>run_stages $@"
	fi

	local package_name="$1"
	shift
	# remaining args should be the stages, at least one.

	local package_path="$(get_package_path $package_name)"
	if [ -z "$package_path" ]; then
		1>&2 echo "No dirt package $package_name"
		exit 3
	fi

	local package_dir="$(dirname "$package_path")"

	local prefix="${DIRT_INSTALL_PATH}/${package_name}"
	mkdir -p "${prefix}"

	local workspace="${DIRT_WORKSPACE_PATH}/${package_name}"
	mkdir -p "${workspace}"

	while [ $# -ge 1 ]; do
		local stage=$1
		shift

		cd "${workspace}"
		PREFIX="${prefix}" PACKAGE_DIR="${package_dir}" make --file="${package_path}" $stage
		if [ 0 -ne $? ]; then
			echo "Failed at stage: $stage"
			exit 6
		fi
	done
}

main $@
