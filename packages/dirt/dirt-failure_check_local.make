# A package that does nothing but fail at the local sanity check.

# The format version of this package.
schema:
	@echo '0'

check_local:
	@echo 'The install should stop here.'
	@false

dependencies_debian:
	echo 'should not reach here'
	false

dependencies_dirt:
	echo 'should not reach here'
	false

fetch:
	echo 'should not reach here'
	false

verify:
	echo 'should not reach here'
	false

extract:
	echo 'should not reach here'
	false

patch:
	echo 'should not reach here'
	false

configure:
	echo 'should not reach here'
	false

build:
	echo 'should not reach here'
	false

test:
	echo 'should not reach here'
	false

install_package:
	echo 'should not reach here'
	false

check_install:
	echo 'should not reach here'
	false

purge:
	echo 'should not reach here'
	false

