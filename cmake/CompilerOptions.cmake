include_guard(GLOBAL)

add_library(cypu_compiler_options INTERFACE)
add_library(Cypu::CompilerOptions ALIAS cypu_compiler_options)

target_compile_features(cypu_compiler_options INTERFACE cxx_std_20)

if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR
   CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
  target_compile_options(cypu_compiler_options INTERFACE
    "$<$<COMPILE_LANGUAGE:CXX>:/permissive->"
    "$<$<COMPILE_LANGUAGE:CXX>:/utf-8>"
    "$<$<COMPILE_LANGUAGE:CXX>:/Zc:__cplusplus>"
    "$<$<COMPILE_LANGUAGE:CXX>:/Zc:preprocessor>"
  )
endif()