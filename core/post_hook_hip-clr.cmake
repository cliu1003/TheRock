# Copyright Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT

# See: https://github.com/ROCm/TheRock/issues/21
if(HIPCC_BIN_DIR)
  message(FATAL_ERROR "The legacy HIPCC_BIN_DIR was somehow set, indicating a bug in the clr CMake files: ${HIPCC_BIN_DIR}")
endif()

# On Windows, HIP >= 7 ships versioned import libraries (amdhip64_7.lib) but clang's
# --hip-link still resolves the legacy amdhip64.lib name.
if(WIN32)
  install(CODE [[
    file(GLOB _versioned_import_libs "${CMAKE_INSTALL_PREFIX}/lib/amdhip64.lib")
    set(_versioned_import_lib)
    foreach(_candidate IN LISTS _versioned_import_libs)
      get_filename_component(_basename "${_candidate}" NAME)
      if(NOT _basename STREQUAL "amdhip64.lib")
        set(_versioned_import_lib "${_candidate}")
        break()
      endif()
    endforeach()
    if(_versioned_import_lib)
      file(COPY "${_versioned_import_lib}" DESTINATION "${CMAKE_INSTALL_PREFIX}/lib")
      get_filename_component(_src_name "${_versioned_import_lib}" NAME)
      file(RENAME
        "${CMAKE_INSTALL_PREFIX}/lib/${_src_name}"
        "${CMAKE_INSTALL_PREFIX}/lib/amdhip64.lib")
    endif()
  ]])
endif()
