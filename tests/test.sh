#!/bin/sh

test_return_code () {
	local expected=$1
	local code=$2
	local message=$3

	if [ $expected -ne $code ]; then
		echo "Expected: $expected"
		echo "Got: $code"
		echo $message
		exit 1
	fi
}

../dirt.sh install dirt-failure_check_local > failure_check_local.test 2>&1
test_return_code 2 $? 'failure_check_local run: FAILED'
diff failure_check_local.test failure_check_local.good > /dev/null 2>&1
test_return_code 0 $? 'failure_check_local test: FAILED'

../dirt.sh --help > help.test 2>&1
test_return_code 0 $? 'help run: FAILED'
diff help.test help.good > /dev/null 2>&1
test_return_code 0 $? 'help test: FAILED'

../dirt.sh install dirt-noop > noop.test 2>&1
test_return_code 0 $? 'noop run: FAILED'
diff noop.test noop.good > /dev/null 2>&1
test_return_code 0 $? 'noop test: FAILED'

../dirt.sh search hello > search.test 2>&1
test_return_code 0 $? 'search run: FAILED'
diff search.test search.good > /dev/null 2>&1
test_return_code 0 $? 'search test: FAILED'

../dirt.sh stage dirt-noop fetch > stage-fetch.test 2>&1
test_return_code 0 $? 'stage-fetch run: FAILED'
diff stage-fetch.test stage-fetch.good > /dev/null 2>&1
test_return_code 0 $? 'stage-fetch test: FAILED'
