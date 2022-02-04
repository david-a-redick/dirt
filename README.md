# What is dirt-debian?

dirt-debian is a dirt simple package manager intended to be run inside an existing debian system, inside a user's home directory.
 
It is a source based personal package manager that draws inspiration from FreeBSD's ports, archlinux's Arch User Repository (AUR), gentoo's portage and little from GoboLinux.

dirt-debian intended to help create official debian packages and experiment with applications not currently in debian.  When possible official debian packages will be used as the dependencies.  dirt-debian focuses on the end application (leaf package) and NOT the entire set of dependencies libraries from scratch.  Also the packages will built as out-of-the-box and vanilla as possible.  If availible, debug settings will be used and very little in the way of optimization or customization is given.

Think of dirt-debian as a [linux-from-scratch](https://www.linuxfromscratch.org/) or gentoo with a very stable core system.  Or even guix but not bothering with providing binaries or repeatable builds.

Think of this as pre-Sid.

# How Does It Work?

dirt-debian is just a POSIX sh ([Bourne shell](https://en.wikipedia.org/wiki/Bourne_shell)) script that follows a life cycle pattern that is a hybred between [port's Makefile](https://docs.freebsd.org/en/books/porters-handbook/order/#porting-order-targets) and [AUR's PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) file.

The `packages` directory contains all the package groups and package files.

There is also a `packages-by-category` that follows the [hierarchy of gentoo's package repo](https://gitweb.gentoo.org/repo/gentoo.git/tree/).  This is mostly for humans that want to browse.

A package is also just a POSIX sh script following a naming pattern of `NAME-VERSION[-FEATURES].sh`, where NAME is the application name lower cased (firefox), version is the official source id (91.0.1esr) and FEATURES are a way to convey that there mutually exclusive compile time features that this package contains.

Each package contains the following functions executed in this order and may contain comments and hints.  You are expected to be able to read the package file and encourage to experiment.

NOTE: There are no pre or post functions as in ports.

`check_local` - A sanity check of the local system.  Good place for things like CPU compatiblity, in case the application has inline assembler.

`list_dependencies_debian` - Space delimited list of debian packages.

`list_dependencies_dirt` - Space delimited list of other dirt packages.

`fetch` - Download the source code.  Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).

`verify` - Perform any check sums or gpg signature verifications.

`extract` - In the cases of bundled release (zip, etc), this step will unpack the bundle.

`patch` - Known as prepare `prepare` in AUR.

`configure` - Configure the source code's build setup.

`build` - Compile and otherwise package up for installation or distribution.

`test` - Run unit tests and perform compilation verification.  Known as `check` in AUR.

`install` - Install the package to the local system.

`check_install` - Any post install checks ands tests.

`purge` - Remove any configuration (dot files) and other files created during run time.


# How Do I Use dirt-debian?

Log into your Debian 11 system and pop open your favorite terminal console.

```shell
git clone TODO

cd dirt-debian

nano configuration.sh

./dirt-debian.sh --help
TODO
```


