cmake_minimum_required(VERSION 3.29)
project(iree_amd_aie_standalone)

set(CMAKE_CXX_STANDARD 17)

find_package(MLIR CONFIG REQUIRED)
find_package(Threads REQUIRED)
find_package(IREECompiler CONFIG REQUIRED)
find_package(IREERuntime CONFIG REQUIRED)

message(STATUS "Using IREE in: ${IREE_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${IREE_CMAKE_DIR}")
include(iree_cc_binary)
# iree_package_name
include(iree_macros)
# IREE_ROOT_DIR
include(iree_copts)
# iree_redirect_llvm_dylib_deps
include(iree_cc_library)

get_property(importTargets DIRECTORY "${CMAKE_SOURCE_DIR}" PROPERTY IMPORTED_TARGETS)

foreach(target ${importTargets})
  get_target_property(aliases ${target} iree_ALIAS_TO)
  if(aliases)
    foreach(alias ${aliases})
      add_library(${alias} ALIAS ${target})
    endforeach()
  endif()
endforeach()

add_subdirectory(tools)
