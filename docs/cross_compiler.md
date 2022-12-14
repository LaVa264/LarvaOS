# GCC Cross-Compiler

This tutorial focuses on creating a GCC cross compiler for your own OS.

This compiler that we build here will have a generic target `i686` what allows you to leave the current OS behind, meaning that **no headers** or libraries of your OS will be used.

You **NEED** a cross-compiler for OS development, otherwise a lot of unexpected things can happen because the compiler assumes that your code is running on your host OS.

## 1. Introduction

A cross-compiler is a compiler that runs on platform A (the host), but generates executables for platform B (the target). These two platforms may (but do not need to) **differ in CPU**, **operating system**, and/or **executable format**.

It is possible ask your compiler what target platform it is currently using by calling the command:
```gcc -dumpmachine```

### 1.1. Why cross-compilers are necessary?

You need to use a cross-compiler unless you are developing on your own operating system. The compiler must know the correct target platform (CPU, operating system), otherwise you will run into trouble. If you use the compiler that comes with your system, then the compiler won't know it is compiling something else entirely.

### 1.2. Which compiler version to choose?

The newest GCC is **RECOMMEND** as it is the latest and greatest release.

### 1.3. Which binutils version to choose?

We **RECOMMEND** that you use the latest and greatest **Binutils** release.

### 1.4. Deciding on the target platform?

You should already know this.
Note on `arm-none-eabi-gcc`: There is the prebuilt package `gcc-arm-none-eabi` on apt-get for **Debian/Ubuntu**, but you shouldn't use it because it neither contains a `libgcc.a` nor freestanding C header files like `stdint.h`.

## 2. Preparing for the build

The GNU Compiler Collection is an advanced piece of software with dependencies. You need the following in order to build GCC:

* A Unix-like environment (Windows users can use the Windows Subsystem for Linux or Cygwin).
* Enough memory and hard disk space (it depends, 256 MiB will not be enough).
* **GCC** (existing release you wish to replace), or another system C compiler.
* **G++** (if building a version of GCC >= 4.8.0), or another system C++ compiler.
* **Make**
* **Bison**     ```apt install bison```
* **Flex**      ```apt install flex```
* **GMP**       ```apt install libgmp3-dev```
* **MPFR**      ```apt install libmpfr-dev```
* **MPC**       ```apt install libmpc-dev```
* **Texinfo**   ```apt install texinfo```
* **ISL** (optional)    ```apt install libisl-dev```
* **CLooG** (optional)  ```apt install libcloog-isl-dev```

You need to have **Texinfo** installed to build Binutils.
You need to have **GMP**, **MPC**, and **MPFR** installed to build GCC. GCC optionally can make use of the CLooG and ISL libraries.

## 3. Downloading the Source Code

You can download the desired **Binutils** release by visiting the [Binutils](https://www.gnu.org/software/binutils/) website or directly accessing the [GNU main mirror](https://ftp.gnu.org/gnu/binutils/).
You can download the desired GCC release by visiting the [GCC](https://www.gnu.org/software/gcc/) website or directly accessing the [GNU main mirror](https://ftp.gnu.org/gnu/gcc/).

## 4. Linux Users building a System Compiler

Your distribution may ship its own patched **GCC** and **Binutils** that is customized to work on your particular Linux distribution.
You should be able to build a working cross-compiler using the above source code, but you might not be able to build a new system compiler for your current Linux distribution.

## 5. The Build

The build a **tool-set** running on your host that can turn source code into object files for your target system. You need to decide **WHERE TO INSTALL** your new compiler. It is **DANGEROUS** and **A VERY BAD IDEA** to install it into system directories.

You also need to decide whether the new compiler should be installed globally or just for you. Installing into `$HOME/opt/cross` is normally a good idea. If you want to install it globally, installing it into `/usr/local/cross` is normally a good idea.

### 5.1. Preparation

```bash
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

We add the installation prefix to the `PATH` of the current shell session. This ensures that the compiler build is able to detect our new **binutils** once we have built them.
The prefix will configure the build process so that all the files of your cross-compiler environment end up in `$HOME/opt/cross`.

### 5.2. Binutils

```bash
cd $HOME/src

mkdir build-binutils
cd build-binutils
../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
```

This compiles the binutils (assembler, disassembler, and various other useful stuff), runnable on your system but handling code in the format specified by `$TARGET`.

* `--disable-nls` tells binutils not to include native language support. This is basically optional, but reduces dependencies and compile time.
* `--with-sysroot` tells binutils to enable `sysroot` support in the cross-compiler by pointing it to a default empty directory.

### 5.3. GCC

**Now, you can build GCC.**

```bash
cd $HOME/src
# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

mkdir build-gcc
cd build-gcc
../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
```

We build **libgcc**, a low-level support library that the compiler expects available at compile time.

* `--disable-nls` is the same as for binutils above.
* `--without-headers` tells GCC not to rely on any C library (standard or runtime) being present for the target.
* `--enable-languages` tells GCC not to compile all the other language front-ends it supports, but only C (and optionally C++).

## 6. Using the new Compiler

Now you have a "**naked**" cross-compiler.

It does not have access to a C library or C runtime yet, so you cannot use any of the standard includes or create runnable binaries. But it is quite sufficient to compile the kernel you will be making shortly.

You can now run your new compiler by invoking something like:

```bash
$HOME/opt/cross/bin/$TARGET-gcc --version
```

Note how this compiler is not able to compile normal C programs.
To use your new compiler simply by invoking `$TARGET-gcc`, add `$HOME/opt/cross/bin` to your `$PATH` by typing:

```bash
export PATH="$HOME/opt/cross/bin:$PATH"
```

This command will add your new compiler to your PATH for this shell session. If you wish to use it permanently, add the `PATH` command to your `~/.profile` configuration shell script or similar.
