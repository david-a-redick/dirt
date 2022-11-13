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

# NOTE: for some reason in proot mktemp can't figure out the /tmp
FILE_RESULTS=$(mktemp -p /tmp dirt.unhook-file.XXX)
DIR_RESULTS=$(mktemp -p /tmp dirt.unhook-dir.XXX)

# careful most the variables in the config
# are real paths, not proot paths.
. /dirt/configuration.sh

cd "/install/$PACKAGE_NAME"
find . -not -type d -print | sed -e 's/^\.\///' > "$FILE_RESULTS"
# make sure we do -depth (depth first) to clean child dirs before the parents
# also, GNU find spits a warning if -depth comes after -type
# also omit the '.' by using -mindepth
find . -mindepth 1 -depth -type d -print | sed -e 's/^\.\///' > "$DIR_RESULTS"

cd "$DIRT_HOOK_PATH"
cat "$FILE_RESULTS" | while IFS= read -r line; do
	rm -f $line
done
cat "$DIR_RESULTS" | while IFS= read -r line; do
	# do not use rm -rf!
	# this may be a directory shared with other packages.
	# rmdir will only delete the directory if it's empty.
	rmdir $line
done

# Clean up
rm -f "$FILE_RESULTS"
rm -f "$DIR_RESULTS"

