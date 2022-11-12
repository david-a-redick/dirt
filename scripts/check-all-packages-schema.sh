#!/bin/sh

LOCATION="$(dirname "$(realpath "$0")")"
PACKAGE_DIR="$(realpath "$LOCATION/..")/packages"

find "$PACKAGE_DIR" -type f -name '*.make' -exec "$LOCATION/check-package-schema.sh" \{\} \;

