#!/bin/sh

# Copyright 2022 - David A. Redick
#
# This file is part of dirt.
#
# dirt is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3 of the License.
#
# dirt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with dirt. If not, see <https://www.gnu.org/licenses/>. 

###
# This is intended to be run in the proot environment, so some of the file paths
# will not line up with the actual system.

main () {
	local package_name=$1
	local stage=$2

	if [ -n "$stage" ]; then
		# We're given a single stage to run.
		run_stages $package_name $stage
	else
		run_all $package_name
	fi
}

run_all () {
	local package_name=$1

	run_stages \
	$package_name \
	fetch \
	verify \
	extract \
	prepare \
	configure \
	build \
	test \
	install_package \
	check_install
}

run_stages () {
	local package_name="$1"
	shift

	while [ $# -ge 1 ]; do
		local stage=$1
		shift

		cd /workspace
		PREFIX="${DIRT_HOOK_PATH}" PACKAGE_DIR="/package" make --file="/package/${package_name}.make" $stage
		if [ 0 -ne $? ]; then
			echo "Failed at stage: $stage"
			exit 6
		fi
	done
}

main $@

