This is the canoncial [proot-me](https://proot-me.github.io) version of proot.
NOT the Termux fork.

Compiles but tests fail

make -C test
make[1]: Entering directory '/workspace/proot-5.3.0/test'
  CHECK	test-00000000 FAILED
  CHECK	test-0228fbe7 FAILED
  CHECK	test-0238c7f1 FAILED
  CHECK	test-03969e70 ok
  CHECK	test-071599da FAILED
  CHECK	test-0830d8a8 skipped
  CHECK	test-092c5e26 FAILED
  CHECK	test-11111111 ok
  CHECK	test-1743dd3d FAILED
  CHECK	test-1cd9d8f9 FAILED
  CHECK	test-1fedd9a3 FAILED
  CHECK	test-1ffc8309 ok
  CHECK	test-22222222 FAILED
  CHECK	test-230f47ch skipped
  CHECK	test-2401b850 FAILED

It hard hangs and I have to kill the term.
