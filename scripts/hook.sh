#!/bin/sh

# Copyright 2022 - David A. Redick
#
# This file is part of dirt.
#
# dirt is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License.
#
# dirt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with dirt. If not, see <https://www.gnu.org/licenses/>. 

# This is intended to be run in the proot environment.

# shows the commands being executed
#set -x

if [ 1 -ne $# ]; then
	echo 'hook.sh PACKAGE_NAME'
	exit 1
fi

PACKAGE_NAME=$1

# careful most the variables in the config
# are real paths, not proot paths.
. /dirt/configuration.sh

cd "/install/$PACKAGE_NAME"
cp -r * "$DIRT_HOOK_PATH"

