#*****************************************************************************#
# Copyright (C) 1994-2017 Lua.org, PUC-Rio.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#*****************************************************************************#

include(CMakePackageConfigHelpers)

# CMake version
cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING 
      "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()

if(NOT BUILD_SHARED_LIBS)
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build shared libraries." FORCE)
endif()

project(lua C)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Project options
option(BUILD_LUA_INTERPRETER "Build the lua interpreter (lua)." ON)
option(BUILD_LUA_COMPILER "Build the lua compiler (luac)." ON)

# Version options
set(LUA_VERSION_MAJOR "5" CACHE INTERNAL "Lua major version")
set(LUA_VERSION_MINOR "3" CACHE INTERNAL "Lua minor version")
set(LUA_VERSION_RELEASE "4" CACHE INTERNAL "Lua release version")
set(LUA_VERSION "${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}.${LUA_VERSION_RELEASE}"
    CACHE INTERNAL "Lua version")

# Install directories
set(LUA_INSTALL_ROOT "")
set(LUA_INSTALL_INCLUDE_DIR "include")
set(LUA_INSTALL_LIB_DIR "lib")
set(LUA_INSTALL_BIN_DIR "bin")
set(LUA_INSTALL_CMAKE_DIR "lib/cmake/lua")

message(STATUS "Lua: ${LUA_VERSION}")
add_definitions(-DLUA_COMPAT_5_2)

# Windows
if(WIN32) 
  if(BUILD_SHARED_LIBS)
    add_definitions(-DLUA_BUILD_AS_DLL)
  endif()
    
# MacOSX
elseif(APPLE)
  add_definitions(-DLUA_USE_MACOSX)
  find_package(Readline)

  if(READLINE_FOUND)
    include_directories(${READLINE_INCLUDE_DIR})    
    list(APPEND LUA_EXTERNAL_LIBS ${READLINE_LIBRARIES})
  endif()

  if(NOT(READLINE_FOUND))
    set(BUILD_LUA_INTERPRETER OFF)
  endif()

  list(APPEND LUA_EXTERNAL_LIBS m)

# Linux and other *nixs
else()
  add_definitions(-DLUA_USE_LINUX)

  if(BUILD_SHARED_LIBS)
    list(APPEND CMAKE_C_FLAGS -fPIC)
  endif()

  find_package(LibDL)
  if(LIBDL_FOUND)
    include_directories(${LIBDL_INCLUDE_DIR})    
    list(APPEND LUA_EXTERNAL_LIBS ${LIBDL_LIBRARIES})
  endif()

  find_package(Readline)
  if(READLINE_FOUND)
    include_directories(${READLINE_INCLUDE_DIR})    
    list(APPEND LUA_EXTERNAL_LIBS ${READLINE_LIBRARIES})
  endif()

  list(APPEND LUA_EXTERNAL_LIBS m)

  if(NOT(READLINE_FOUND))
    set(BUILD_LUA_INTERPRETER OFF)
  endif()
endif()

add_subdirectory(src)
 
# Generate lua-config-version.cmake
set(version_file "${CMAKE_BINARY_DIR}/${LUA_INSTALL_CMAKE_DIR}/lua-config-version.cmake")
write_basic_package_version_file(
  "${version_file}"
  VERSION ${LUA_VERSION}
  COMPATIBILITY AnyNewerVersion
)

# Generate lua-config.cmake
set(config_file "${CMAKE_BINARY_DIR}/${LUA_INSTALL_CMAKE_DIR}/lua-config.cmake")
configure_package_config_file(
  "${CMAKE_SOURCE_DIR}/cmake/lua-config.cmake.in" 
  "${config_file}"
  INSTALL_DESTINATION "${LUA_INSTALL_CMAKE_DIR}"
   PATH_VARS 
     LUA_INSTALL_ROOT
     LUA_INSTALL_INCLUDE_DIR
     LUA_INSTALL_LIB_DIR
     LUA_INSTALL_BIN_DIR
     LUA_INSTALL_CMAKE_DIR
)

install(FILES ${version_file} ${config_file} DESTINATION "${LUA_INSTALL_CMAKE_DIR}")
