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

# The full path to the directory of this script file.
LOCATION="$(dirname "$(realpath "$0")")"

PATH_TO_PACKAGE="$1"
PACKAGE_NAME=$(basename "$1")

PACKAGE_RESULTS=$(mktemp dirt.chk-pkg-scm.XXX)

grep '^[[:alpha:]]*:' "$PATH_TO_PACKAGE" > "$PACKAGE_RESULTS"
diff "$PACKAGE_RESULTS" "$LOCATION/schema-0-list.good" > /dev/null 2>&1

if [ 0 -ne $? ]; then
	echo "$PACKAGE_NAME not a strict schema 0 package."
fi

rm "$PACKAGE_RESULTS"
