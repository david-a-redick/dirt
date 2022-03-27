all: run clean
	@echo 'Done'

test:
	@echo 'this should not be seen' > /dev/null 2>&1

clean:
	@rm -f *.test

# This give different results than just running it from a shell
run:
	@./test.sh
