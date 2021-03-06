##############################################################################
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
##############################################################################

# - Find re2 headers and lib.
# RE2_HOME hints the location
# This module defines
#  RE2_INCLUDE_DIR, directory containing headers
#  RE2_STATIC_LIB, path to libre2.a
#  RE2_SHARED_LIB, path to libre2.so
#  RE2_FOUND, whether re2 has been found

if( NOT "${RE2_HOME}" STREQUAL "")
    file (TO_CMAKE_PATH "${RE2_HOME}" _re2_path)
endif()
message (STATUS "RE2_HOME: ${RE2_HOME}")

find_path(RE2_INCLUDE_DIR re2/re2.h
  HINTS ${_re2_path}
  NO_DEFAULT_PATH
  PATH_SUFFIXES "include"
  DOC  "Google's re2 regex header path"
)

set (lib_dirs "lib")
if (EXISTS "${_re2_path}/lib64")
  set (lib_dirs "lib64" ${lib_dirs})
endif ()
if (EXISTS "${_re2_path}/lib/${CMAKE_LIBRARY_ARCHITECTURE}")
  set (lib_dirs "lib/${CMAKE_LIBRARY_ARCHITECTURE}" ${lib_dirs})
endif ()

find_library(RE2_STATIC_LIB NAMES libre2${CMAKE_STATIC_LIBRARY_SUFFIX}
  PATHS ${_re2_path}
        NO_DEFAULT_PATH
  PATH_SUFFIXES ${lib_dirs}
  DOC   "Google's re2 regex static library"
)

find_library(RE2_SHARED_LIB NAMES libre2${CMAKE_SHARED_LIBRARY_SUFFIX}
  PATHS ${_re2_path}
        NO_DEFAULT_PATH
  PATH_SUFFIXES ${lib_dirs}
  DOC   "Google's re2 regex static library"
)

message(STATUS ${RE2_INCLUDE_DIR})

if (ARROW_RE2_LINKAGE STREQUAL "static" AND (NOT RE2_STATIC_LIB))
  set(RE2_LIB_NOT_FOUND TRUE)
elseif(ARROW_RE2_LINKAGE STREQUAL "shared" AND (NOT RE2_SHARED_LIB))
  set(RE2_LIB_NOT_FOUND TRUE)
endif()

if (NOT RE2_INCLUDE_DIR OR RE2_LIB_NOT_FOUND)
  set(RE2_FOUND FALSE)
  if (_re2_path)
    set (RE2_ERR_MSG "Could not find re2. Looked in ${_re2_path}.")
  else ()
    set (RE2_ERR_MSG "Could not find re2 in system search paths.")
  endif()

  if (RE2_FIND_REQUIRED)
    message(FATAL_ERROR "${RE2_ERR_MSG})")
  else ()
    message (STATUS "${RE2_ERR_MSG}")
  endif ()
else()
    set(RE2_FOUND TRUE)
    message(STATUS "RE2 headers : ${RE2_INCLUDE_DIR}")
    message(STATUS "RE2 static library : ${RE2_STATIC_LIB}")
    message(STATUS "RE2 shared library : ${RE2_SHARED_LIB}")
endif()

mark_as_advanced(
  RE2_INCLUDE_DIR
  RE2_SHARED_LIB
  RE2_STATIC_LIB
)
