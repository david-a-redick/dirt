# Status

Alpha but actually does stuff.

# What is dirt?

dirt is a dirt simple package manager intended to be run inside an existing Debian system, inside a user's home directory.
 
It is a source based personal package manager that draws inspiration from [FreeBSD's ports](https://www.freshports.org), [archlinux's Arch User Repository](https://aur.archlinux.org/packages) (AUR), [gentoo's portage](https://packages.gentoo.org) and little from [GoboLinux](https://gobolinux.org).

dirt intended to help create official Debian packages and experiment with applications not currently in Debian.  When possible official Debian packages will be used as the dependencies.  dirt focuses on the end application (leaf package) and NOT the entire set of dependencies libraries from scratch.  Also the packages will built as out-of-the-box and vanilla as possible.  If availible, debug settings will be used and very little in the way of optimization or customization is given.

Think of dirt as a [linux-from-scratch](https://www.linuxfromscratch.org/) or AUR with a very stable core system.

Think of this as a place for [WNPP](https://www.debian.org/devel/wnpp/) and pre-Sid packages.

# How Does It Work?

dirt is just a POSIX sh ([Bourne shell](https://en.wikipedia.org/wiki/Bourne_shell)) script that follows a life cycle pattern that is a hybred between [port's Makefile](https://docs.freebsd.org/en/books/porters-handbook/order/#porting-order-targets) and [AUR's PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) file.

The `packages` directory contains all the package groups and package files.

There is also a `packages-by-category-gentoo` that follows the [hierarchy of gentoo's package repo](https://gitweb.gentoo.org/repo/gentoo.git/tree/).  This is mostly for humans that want to browse.

A package is just a Makefile following a naming pattern of `NAME-VERSION[-FEATURES].make`, where NAME is the application name lower cased (firefox), version is the official source id (91.0.1esr) and FEATURES are a way to convey that there mutually exclusive compile time features that this package contains.

Each package contains the following make targets executed in this order and may contain comments and hints.  You are expected to be able to read the package file and encourage to experiment.

NOTE: There are no pre or post functions as in ports.

`check_local` - A sanity check of the local system.  Good place for things like CPU compatiblity, in case the application has inline assembler.

`dependencies_debian` - Will run `sudo apt-get install ...` for all the debian packages.

`dependencies_dirt` - Will run `dirt.sh install ...` for all the dirt packages.

`fetch` - Download the source code.  Could be cloning the repo (preferred) or could be a packaged release bundle (tar ball, etc).

`verify` - Perform any check sums or gpg signature verifications.

`extract` - In the cases of bundled release (zip, etc), this step will unpack the bundle.

`prepare` - Known as prepare `patch` in ports.  Had to use this name to prevent collision with the [patch program](https://www.gnu.org/software/diffutils/manual/html_node/Merging-with-patch.html).

`configure` - Configure the source code's build setup.

`build` - Compile and otherwise package up for installation or distribution.

`test` - Run unit tests and perform compilation verification.  Known as `check` in AUR.

`install_package` - Install the package to the local system.  Had to add '_package' prefix to prevent collision with the [install program](https://www.gnu.org/software/coreutils/install)

`check_install` - Any post install checks ands tests.

`purge` - Remove any configuration (dot files) and other files created during run time.


# How Do I Use dirt?

Log into your Debian 11 system and pop open your favorite terminal console.

```shell
$ sudo apt-get install git proot

$ git clone https://github.com/david-a-redick/dirt.git

$ cd dirt

$ nano configuration.sh

$ ./dirt.sh --help
dirt.sh COMMAND PACKAGE_NAME

search NAME - Will search for any hits on the given NAME in both package files and group directories.

install PACKAGE_NAME - Will run through the all the stages from `check_local` to `check_install`

stage PACKAGE_NAME STAGE_NAME - Will only run the given stage for the given package.

proot PACKAGE_NAME - Will create a proot environment and create a shell for you to explore.

hook PACKAGE_NAME - Will hook the package into use in the local environment (by default ~/.local).

unhook PACKAGE_NAME - Will remove all the file done by the `hook` command.

clean PACKAGE_NAME - Will unhook, delete the install and workspace directories of the package.
```

Download and compile and bundle an example package.

```shell
./dirt.sh install nano-6.0
```

Hook it into the local environment (~/.local or /opt if you're brave).

```shell
./dirt.sh hook nano-6.0
```

Play, test and when you're done.

```shell
./dirt.sh unhook nano-6.0
```

# How To Make A Package

```shell
$ mkdir packages/FOO
$ ./scripts/print-package-template.sh > ./packages/FOO/FOO-1.2.3.make
$ cd packages-by-category/GENTOO-CATEGORY/
$ ln -s ../../packages/FOO FOO
$ cd ../..
$ nano ./packages/FOO/FOO-1.2.3.make
$ ./dirt.sh install FOO-1.2.3
```

# Tested On

```shell
$ uname -a
Linux hydrogen 5.10.0-11-amd64 #1 SMP Debian 5.10.92-1 (2022-01-18) x86_64 GNU/Linux
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Debian
Description:	Debian GNU/Linux 11 (bullseye)
Release:	11
Codename:	bullseye
```
