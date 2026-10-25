cmake_minimum_required(VERSION 3.28)
project(yosys-lean LANGUAGES NONE)

option(YOSYS_LEAN_BUILD_YOSYS "Fetch and build the pinned Yosys dependency" ON)
set(YOSYS_SOURCE_DIR "" CACHE PATH "Optional matching Yosys source checkout (FunctionalIR headers)")

if(YOSYS_LEAN_BUILD_YOSYS)
  include(ExternalProject)
  set(YOSYS_BUILD_DIR "${CMAKE_BINARY_DIR}/yosys" CACHE PATH "Yosys dependency build directory")
  set(YOSYS_BUILD_JOBS 3 CACHE STRING "Parallel jobs for the separate Yosys build")
  set(yosys_revision 3718f7f135dc25381c50f18e550bdc5f48663ec3)
  if(YOSYS_SOURCE_DIR)
    # Reuse a checkout without downloading, updating, or modifying its Git state.
    if(NOT EXISTS "${YOSYS_SOURCE_DIR}/kernel/functional.h")
      message(FATAL_ERROR "YOSYS_SOURCE_DIR must contain kernel/functional.h")
    endif()
    set(yosys_download SOURCE_DIR "${YOSYS_SOURCE_DIR}" DOWNLOAD_COMMAND "" UPDATE_COMMAND "")
  else()
    set(YOSYS_SOURCE_DIR "${CMAKE_BINARY_DIR}/_deps/yosys-src")
    set(yosys_download
      SOURCE_DIR "${YOSYS_SOURCE_DIR}"
      GIT_REPOSITORY https://github.com/YosysHQ/yosys.git
      GIT_TAG "${yosys_revision}"
      GIT_SUBMODULES libs/cxxopts libs/fmt libs/tomlplusplus libs/boost_regex libs/symfpu
      GIT_SUBMODULES_RECURSE FALSE
      UPDATE_DISCONNECTED TRUE)
  endif()
  ExternalProject_Add(yosys-dependency
    ${yosys_download}
    BINARY_DIR "${YOSYS_BUILD_DIR}"
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CXX_FLAGS_RELEASE=-O1
      -DYOSYS_WITHOUT_ABC=ON -DYOSYS_WITHOUT_SLANG=ON -DYOSYS_WITHOUT_TCL=ON
      -DYOSYS_ENABLE_UNIT_TESTS=OFF -DYOSYS_USE_BUNDLED_LIBS=ON
    BUILD_COMMAND "${CMAKE_COMMAND}" --build <BINARY_DIR> --parallel "${YOSYS_BUILD_JOBS}"
    BUILD_BYPRODUCTS "${YOSYS_BUILD_DIR}/yosys" "${YOSYS_BUILD_DIR}/yosys-config"
    BUILD_ALWAYS TRUE
    INSTALL_COMMAND "")
  set(YOSYS_EXECUTABLE "${YOSYS_BUILD_DIR}/yosys")
  set(YOSYS_CONFIG "${YOSYS_BUILD_DIR}/yosys-config")
else()
  find_program(YOSYS_EXECUTABLE yosys REQUIRED)
  find_program(YOSYS_CONFIG yosys-config REQUIRED)
  # Installed packages may omit FunctionalIR headers. The matching source tree
  # can provide them without rebuilding Yosys or changing the installed package.
endif()

set(plugin_include_args)
foreach(dir IN ITEMS "${YOSYS_SOURCE_DIR}" "${YOSYS_BUILD_DIR}")
  if(dir)
    list(APPEND plugin_include_args "-I${dir}")
  endif()
endforeach()
add_custom_command(OUTPUT "${CMAKE_BINARY_DIR}/yosys_lean.so"
  COMMAND "${YOSYS_CONFIG}" --build "${CMAKE_BINARY_DIR}/yosys_lean.so"
    "${PROJECT_SOURCE_DIR}/src/lean.cc" ${plugin_include_args}
  DEPENDS src/lean.cc "${YOSYS_CONFIG}" "${YOSYS_EXECUTABLE}" VERBATIM)
add_custom_target(yosys-lean ALL DEPENDS "${CMAKE_BINARY_DIR}/yosys_lean.so")
if(YOSYS_LEAN_BUILD_YOSYS)
  add_dependencies(yosys-lean yosys-dependency)
endif()

include(CTest)
if(BUILD_TESTING)
  find_package(Python3 3.10 REQUIRED COMPONENTS Interpreter)
  find_program(LAKE_EXECUTABLE lake REQUIRED)
  find_program(Z3_EXECUTABLE z3 REQUIRED)
  find_program(IVERILOG_EXECUTABLE iverilog REQUIRED)
  find_program(VVP_EXECUTABLE vvp REQUIRED)
  add_test(NAME exporter-and-proofs COMMAND "${Python3_EXECUTABLE}" "${PROJECT_SOURCE_DIR}/tests/run.py"
    --yosys "${YOSYS_EXECUTABLE}" --plugin "${CMAKE_BINARY_DIR}/yosys_lean.so"
    --work "${CMAKE_BINARY_DIR}/tests" --lake "${LAKE_EXECUTABLE}"
    --z3 "${Z3_EXECUTABLE}" --iverilog "${IVERILOG_EXECUTABLE}" --vvp "${VVP_EXECUTABLE}")
  set_tests_properties(exporter-and-proofs PROPERTIES TIMEOUT 600
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
  add_test(NAME nerv-faults COMMAND "${Python3_EXECUTABLE}" "${PROJECT_SOURCE_DIR}/tests/nerv_faults.py"
    --yosys "${YOSYS_EXECUTABLE}" --plugin "${CMAKE_BINARY_DIR}/yosys_lean.so"
    --work "${CMAKE_BINARY_DIR}/nerv-fault-tests" --lake "${LAKE_EXECUTABLE}"
    --z3 "${Z3_EXECUTABLE}" --iverilog "${IVERILOG_EXECUTABLE}" --vvp "${VVP_EXECUTABLE}")
  set_tests_properties(nerv-faults PROPERTIES TIMEOUT 900
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
  # Even `ctest -j` must not start simultaneous proof-checking processes.
  set_tests_properties(exporter-and-proofs nerv-faults PROPERTIES RUN_SERIAL TRUE)
endif()
