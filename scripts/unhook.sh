#!/bin/sh

# is this a file-file or a directory-file?
# string 'file' for file-file
# string 'dir' for directory file
is_file_or_dir=$1

DIRT_INSTALL_PATH=$2

DIRT_HOOK_PATH=$3

package_name=$4

# could be a file-file or a directory-file
installed_file_path=$5

file_sans_prefix=${installed_file_path#*$DIRT_INSTALL_PATH/}
file_sans_prefix=${file_sans_prefix#*$package_name/}

hooked_file="$DIRT_HOOK_PATH/$file_sans_prefix"

#echo "$hooked_file"
#exit 0

if [ 'file' = $is_file_or_dir ]; then
	rm -f "$hooked_file"
elif  [ 'dir' = $is_file_or_dir ]; then
	# do not use rm -rf!
	# this may be a directory shared with other packages.
	# rmdir will only delete the directory if it's empty.
	rmdir "$hooked_file" >/dev/null 2>&1
else
	echo "first arg must be 'file' or 'dir'"
	exit 1
fi
