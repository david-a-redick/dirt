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

LOCATION="$(dirname "$(realpath "$0")")"
PACKAGE_DIR="$(realpath "$LOCATION/..")/packages"

find "$PACKAGE_DIR" -type f -name '*.make' -exec "$LOCATION/check-package-schema.sh" \{\} \;

