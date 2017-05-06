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

# CMake version
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# Set default build-type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING 
      "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

project(lua C)

# Project options
option(BUILD_SHARED_LIBS "Build shared instead of static libraries." ON)
option(BUILD_LUA_INTERPRETER "Build the lua interpreter (lua)." ON)
option(BUILD_LUA_COMPILER "Build the lua compiler (luac)." ON)

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

