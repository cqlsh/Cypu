include_guard(GLOBAL)

function(cypu_set_output_directories targetName)
  set(binaryDirectory "${Cypu_BINARY_DIR}/bin/$<CONFIG>")
  set(libraryDirectory "${Cypu_BINARY_DIR}/lib/$<CONFIG>")

  # The generator expression prevents duplicate configuration subdirectories.
  set_target_properties("${targetName}" PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${binaryDirectory}" LIBRARY_OUTPUT_DIRECTORY "${libraryDirectory}"
    ARCHIVE_OUTPUT_DIRECTORY "${libraryDirectory}" PDB_OUTPUT_DIRECTORY "${binaryDirectory}")
endfunction()