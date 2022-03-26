#!/bin/sh

# Just a little helper because writing function in Make sucks.

expected=$1
code=$2
message=$3

if [ $expected -ne $code ]; then
	echo "$message"
	exit 1
fi
