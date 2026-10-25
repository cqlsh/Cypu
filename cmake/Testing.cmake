include_guard(GLOBAL)

function(cypu_add_test targetName)
  if(NOT TARGET "${targetName}")
    message(FATAL_ERROR "Cannot register missing Cypu test target '${targetName}'.")
  endif()

  get_target_property(targetType "${targetName}" TYPE)
  if(NOT targetType STREQUAL "EXECUTABLE")
    message(FATAL_ERROR "Cypu test target '${targetName}' must be an executable.")
  endif()

  add_test(NAME "${targetName}" COMMAND "${targetName}")
  set_tests_properties("${targetName}" PROPERTIES WORKING_DIRECTORY "$<TARGET_FILE_DIR:${targetName}>" TIMEOUT 60 LABELS "cypu")
endfunction()