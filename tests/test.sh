#!/bin/sh

# Copyright 2020 - David A. Redick
#
# This file is part of dirt.
#
# dirt is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3 of the License.
#
# dirt is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with dirt. If not, see <https://www.gnu.org/licenses/>. 

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
test_return_code 6 $? 'failure_check_local run: FAILED'
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

../dirt.sh foo bar > unknown_command.test 2>&1
test_return_code 2 $? 'unknown_command run: FAILED'
diff unknown_command.test unknown_command.good > /dev/null 2>&1
test_return_code 0 $? 'unknown_command test: FAILED'

../dirt.sh foo > run_hint.test 2>&1
test_return_code 1 $? 'run_hint run: FAILED'
diff run_hint.test run_hint.good > /dev/null 2>&1
test_return_code 0 $? 'run_hint test: FAILED'


rm *.test
