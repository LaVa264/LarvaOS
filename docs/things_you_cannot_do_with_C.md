# Things you cannot do with C

## 1. C

C is a **minimalistic programming language** which is platform independent and requires no runtime. Because of these qualities it has become by far the most used language in the field of OS development and system programming. It can be compared to a "**portable Assembly**", as it was initially designed and used for.

## 2. Compilers

A complex compiler is not required to compile C because of its **minimalistic qualities**. As a result many various compilers have been written for C and will work for OS development.

Today the two most common are GCC. GCC being the far most common in open source development.

## 3. Libraries

The C Library implements the standard C functions and provides them in binary form suitable for linking with user-space applications. In addition to standard C functions (as defined in the ISO standard), a C library might (and usually does) implement further functionality, which might or might not be defined by some standard. The standard C library **says nothing about networking**, for example.

It should be noted that, in order to implement its functionally, the C library must call kernel functions through **system calls**.

It should also be noted that you can not use a user mode C library directly in your kernel as kernel code needs to be **compiled specially**. Things such as `malloc`, `free`, `memcpy` need to implemented by you before being used.

## 3. Things C can't do

- Because of the platform independent nature of C some parts of OS development **CAN ONLY BE DONE IN ASSEMBLY**. Others can be implemented using **inline Assembly**, but still require knowledge outside the realm of your high-level language of choice. The canonical example of code that must be written in pure Assembly is the **FIRST-STAGE boot-loader**.

- If you choice to write your own instead of using an existing solution such as GRUB, it **MUST** be written in Assembly, as it requires direct manipulation of certain registers; specifically, the **segment selectors** and **the stack pointer**, which would not be possible in C itself.

- Others functions, such as loading the Global Descriptor Table (on the IA32 architecture), also require special opcodes which are not available within C language (but can be implemented in Assembly inline).

- In the (unlikely) case your compiler does not support inline Assembly, you have the option of writing 'support functions' in a separate Assembly file.

- **Interrupt Service Routines (ISRs)** also require some special handling, because they are called directly by the CPU, not by the C environment.

## 4. Things you should know about optimizations

At some point you might want to compile your code with optimizations enabled. This however can lead to unpredictable if your C code wasn't written properly.
