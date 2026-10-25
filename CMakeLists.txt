cmake_minimum_required(VERSION 3.24)

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_CURRENT_BINARY_DIR)
  message(FATAL_ERROR "Use an out-of-source build: cmake -S . -B out/build")
endif()

project(Cypu
  VERSION 0.1.0
  DESCRIPTION "The Cypu programming language"
  LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(CYPU_BUILD_TOOLS "Build Cypu developer tools" ON)
option(CYPU_BUILD_TESTS "Build Cypu tests" ${PROJECT_IS_TOP_LEVEL})
option(CYPU_BUILD_BENCHMARKS "Build Cypu benchmarks" OFF)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Build helpers become available as the project is assembled.
foreach(module IN ITEMS CompilerOptions CompilerWarnings OutputDirectories Sanitizers)
  include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/${module}.cmake" OPTIONAL)
endforeach()

# Register only components whose build files have already been added.
function(cypu_add_component directory)
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${directory}/CMakeLists.txt")
    add_subdirectory("${directory}")
  endif()
endfunction()

cypu_add_component(runtime)
cypu_add_component(stdlib)
cypu_add_component(compiler)

if(CYPU_BUILD_TOOLS)
  cypu_add_component(tools)
endif()

if(CYPU_BUILD_TESTS)
  enable_testing()
  include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/Testing.cmake" OPTIONAL)
  cypu_add_component(tests)
endif()

if(CYPU_BUILD_BENCHMARKS)
  cypu_add_component(benchmarks)
endif()