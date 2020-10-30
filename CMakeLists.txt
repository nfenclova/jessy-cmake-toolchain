cmake_minimum_required(VERSION "3.14.0")

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/GNU-x86_64-elf.cmake")

project("jessy-cmake-toolchain"
  LANGUAGES ASM
)

option(TEST_TOOLCHAIN "Build a test executable to verify the toolchain" OFF)

### Runtime Support

add_library("jessy-rt" STATIC
  "src/runtime.s"
)

function(jessy_link_runtime TGT)
  target_link_libraries("${TGT}" PRIVATE
    "-Wl,--whole-archive"
    "jessy-rt"
    "-Wl,--no-whole-archive"
  )
endfunction()


### Toolchain Tests

if(TEST_TOOLCHAIN)
  enable_language(CXX)
  add_executable("jessy-cmake-toolchain-test" "test/toolchain-test.cpp")
  target_link_directories("jessy-cmake-toolchain-test" PRIVATE "${PROJECT_SOURCE_DIR}/test")
  jessy_link_runtime("jessy-cmake-toolchain-test")
  target_link_options("jessy-cmake-toolchain-test" PRIVATE "-Ttest.ld")
endif()