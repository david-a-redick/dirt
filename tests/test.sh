#!/bin/sh

test_return_code () {
	local code=$1
	local message=$2

	if [ 0 -ne $code ]; then
		echo $message
		exit 1
	fi
}

../dirt.sh --help > help.test
test_return_code $? 'help run: FAILED'
diff help.test help.good
test_return_code $? 'help test: FAILED'

../dirt.sh search hello > search.test
test_return_code $? 'search run: FAILED'
diff search.test search.good
test_return_code $? 'search test: FAILED'


