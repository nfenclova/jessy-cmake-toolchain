cmake_minimum_required(VERSION "3.6.0")

set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_PROCESSOR "x86_64")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TARGET_TRIPLE "${CMAKE_SYSTEM_PROCESSOR}-elf")

### Find the Toolchain's Tools

find_program(CMAKE_OBJDUMP "${TARGET_TRIPLE}-objdump" DOC "Path to the target platform's objdump")
find_program(CMAKE_OBJCOPY "${TARGET_TRIPLE}-objcopy" DOC "Path to the target platform's objcopy")
find_program(CMAKE_NM "${TARGET_TRIPLE}-nm" DOC "Path to the target platform's nm")
find_program(CMAKE_CXX_COMPILER_RANLIB "${TARGET_TRIPLE}-ranlib" DOC "Path to the target platform's ranlib")
find_program(CMAKE_STRIP "${TARGET_TRIPLE}-strip" DOC "Path to the target platform's strip")
find_program(CMAKE_LINKER "${TARGET_TRIPLE}-ld" DOC "Path to the target platform's ld")
find_program(CMAKE_CXX_COMPILER_AR "${TARGET_TRIPLE}-ar" DOC "Path to the target platform's ar")
find_program(CMAKE_CXX_COMPILER "${TARGET_TRIPLE}-g++" DOC "Path to the target platform's g++")

### Find System Root

execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "-print-file-name=crtbegin.o"
  OUTPUT_VARIABLE CROSS_GCC_CRTBEGIN
  ERROR_QUIET
  )
string(STRIP ${CROSS_GCC_CRTBEGIN} CROSS_GCC_CRTBEGIN)
mark_as_advanced(CROSS_GCC_CRTBEGIN)

string(REGEX REPLACE "/crtbegin.o" "" CMAKE_SYSROOT ${CROSS_GCC_CRTBEGIN})
mark_as_advanced(CMAKE_SYSROOT)

### Configure Compiler

set(CMAKE_CXX_FLAGS_INIT
  "-ffreestanding \
  -nostdlib \
  -m64 \
  -mno-red-zone \
  -mcmodel=large \
  -ffunction-sections \
  -fdata-sections"
  )

### Configure Linker

set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,-n,--gc-sections,--build-id=none -fuse-ld=bfd")
set(CMAKE_CXX_LINK_EXECUTABLE
  "<CMAKE_CXX_COMPILER> \
  <FLAGS> \
  <CMAKE_CXX_LINK_FLAGS> \
  <LINK_FLAGS> \
  ${CMAKE_SYSROOT}/crtbegin.o \
  <OBJECTS> \
  -o <TARGET> \
  <LINK_LIBRARIES> \
  ${CMAKE_SYSROOT}/crtend.o"
)
