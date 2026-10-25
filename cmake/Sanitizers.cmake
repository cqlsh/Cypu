include_guard(GLOBAL)

option(CYPU_ENABLE_ASAN "Enable AddressSanitizer for Cypu" OFF)
option(CYPU_ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer for Cypu" OFF)

add_library(cypu_sanitizers INTERFACE)
add_library(Cypu::Sanitizers ALIAS cypu_sanitizers)

if(NOT CYPU_ENABLE_ASAN AND NOT CYPU_ENABLE_UBSAN)
  return()
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
  if(CYPU_ENABLE_UBSAN)
    message(FATAL_ERROR "Cypu does not configure UBSan for MSVC-style toolchains. Disable CYPU_ENABLE_UBSAN.")
  endif()

  # Override conflicting flags in this directory without changing cached user settings.
  foreach(cypuConfig IN ITEMS Debug Release RelWithDebInfo MinSizeRel ${CMAKE_CONFIGURATION_TYPES} ${CMAKE_BUILD_TYPE})
    string(TOUPPER "${cypuConfig}" cypuConfigUpper)
    set(cypuFlagVariable "CMAKE_CXX_FLAGS_${cypuConfigUpper}")
    string(REGEX REPLACE "(^|[ \t])[-/]RTC[1csu]+" "\\1" "${cypuFlagVariable}" "${${cypuFlagVariable}}")
  endforeach()

  string(REGEX REPLACE "(^|[ \t])[-/]RTC[1csu]+" "\\1" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  target_compile_options(cypu_sanitizers INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:/fsanitize=address;/Zi>")
  target_link_options(cypu_sanitizers INTERFACE /INCREMENTAL:NO)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
  set(cypuSanitizerNames "")

  if(CYPU_ENABLE_ASAN)
    list(APPEND cypuSanitizerNames address)
  endif()

  if(CYPU_ENABLE_UBSAN)
    list(APPEND cypuSanitizerNames undefined)
  endif()

  list(JOIN cypuSanitizerNames "," cypuSanitizerList)
  target_compile_options(cypu_sanitizers INTERFACE
    "$<$<COMPILE_LANGUAGE:CXX>:-fsanitize=${cypuSanitizerList};-fno-omit-frame-pointer;-fno-sanitize-recover=all;-g>")
  target_link_options(cypu_sanitizers INTERFACE "-fsanitize=${cypuSanitizerList}")
else()
  message(FATAL_ERROR "Cypu sanitizer options are not configured for compiler '${CMAKE_CXX_COMPILER_ID}'.")
endif()