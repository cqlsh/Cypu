include_guard(GLOBAL)

option(CYPU_WARNINGS_AS_ERRORS "Treat Cypu compiler warnings as errors" OFF)

add_library(cypu_compiler_warnings INTERFACE)
add_library(Cypu::CompilerWarnings ALIAS cypu_compiler_warnings)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
  target_compile_options(cypu_compiler_warnings INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:/W4>")

  if(CYPU_WARNINGS_AS_ERRORS)
    target_compile_options(cypu_compiler_warnings INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:/WX>")
  endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
  target_compile_options(cypu_compiler_warnings INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Wall>" "$<$<COMPILE_LANGUAGE:CXX>:-Wextra>"
    "$<$<COMPILE_LANGUAGE:CXX>:-Wpedantic>" "$<$<COMPILE_LANGUAGE:CXX>:-Wconversion>" "$<$<COMPILE_LANGUAGE:CXX>:-Wsign-conversion>"
    "$<$<COMPILE_LANGUAGE:CXX>:-Wshadow>" "$<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>" "$<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>")

  if(CYPU_WARNINGS_AS_ERRORS)
    target_compile_options(cypu_compiler_warnings INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Werror>")
  endif()
endif()