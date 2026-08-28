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
    set(_lib_dir "${CMAKE_INSTALL_PREFIX}/lib")
    set(_legacy_lib "${_lib_dir}/amdhip64.lib")
    if(NOT EXISTS "${_legacy_lib}")
      file(GLOB _versioned_libs "${_lib_dir}/amdhip64_*.lib")
      if(_versioned_libs)
        list(GET _versioned_libs 0 _src)
        execute_process(COMMAND "${CMAKE_COMMAND}" -E copy "${_src}" "${_legacy_lib}")
      endif()
    endif()
  ]])
endif()
