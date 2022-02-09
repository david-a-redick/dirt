###
###  WARNING USE FULL ABSOLUTE PATH!!
###

# All downloaded source code and other stuff will be placed here.
# and patched and compiled.
# dirt assumes you want to hack and fiddle with the code, so it's left for you.
# One subdirectory for each package.
DIRT_WORKSPACE_PATH=$HOME/source/dirt/workspace
#DIRT_WORKSPACE_PATH=/home/redick/source/dirt/workspace

# dirt will placed the completed and installed packages here.
# One subdirectory for each package.
DIRT_INSTALL_PATH=$HOME/source/dirt/install
#DIRT_INSTALL_PATH=/home/redick/source/dirt/install

# This is were you want to actually access the package for use.
# A real install-install.
# Make sure you have $DIRT_HOOK_PATH/bin in your $PATH
# And $DIRT_HOOK_PATH/lib in $LD_LIBRARY_PATH
DIRT_HOOK_PATH=$HOME/.local

#DIRT_HOOK_PATH=/opt
#DIRT_HOOK_PATH=/usr/local
#DIRT_HOOK_PATH=/usr
