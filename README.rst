=====================
jessy-cmake-toolchain
=====================

``jessy-cmake-toolchain`` provides a `CMake <https://cmake.org>` toolchain file for:

- `The jessy Kernel <https://github.com/nfenclova/jessy>`_
- `The jessy-cpplib Standard Library <https://github.com/nfenclova/jessy-cpplib>`_

as well as a runtime support library ``jessy-rt``, required to ensure the global constructors and destructors are run correctly.
The toolchain file is designed to be used with the `GNU Compiler Collection <https://gcc.gnu.org>`_, built for the ``x86_64-elf`` target.

Usage
=====

To use the toolchain file and the library, include this repository in the consuming build configuration.
An easy method to do so is to use the `CMake FetchContent Module <https://cmake.org/cmake/help/latest/module/FetchContent.html>`_, as shown below:

.. code-block:: cmake

   cmake_minimum_required(VERSION "3.14.0")

   include("FetchContent")
   
   FetchContent_Declare("jessy-cmake-toolchain"
     GIT_REPOSITORY "https://github.com/nfenclova/jessy-cmake-toolchain.git"
     GIT_TAG "master"
   )
   FetchContent_MakeAvailable("jessy-cmake-toolchain")

   project("ConsumerOfToolchain")

Linking Against the Runtime Support Library
-------------------------------------------

Because the GCC cross-compilation toolchain does provide neither ``crti.o`` nor ``crtn.o``, ``jessy-cmake-toolchain`` ships with a simple implementation of both of these files.
In order to link against this implementation, the``jessy_link_runtime(<TGT>)`` is provided.
Additionally, the code from the following sections needs to be place appropriately during linking:

- ``.jessy_crti_init``
- ``.jessy_crtn_init``
- ``.jessy_crti_fini``
- ``.jessy_crtn_fini``

This can be achieved using a linker script similar to the one shown below:

.. code-block::

   SECTIONS
   {
     .init ALIGN(4K) : AT(ADDR (.init))
     {
       KEEP(*(.jessy_crti_init))
       KEEP(*(.init))
       KEEP(*(.jessy_crtn_init))
     }
   
     .fini ALIGN(4K) : AT(ADDR (.fini))
     {
       KEEP(*(.jessy_crti_fini))
       KEEP(*(.fini))
       KEEP(*(.jessy_crtn_fini))
     }
   }