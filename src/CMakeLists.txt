#*****************************************************************************#
# Copyright (C) 1994-2017 Lua.crg, PUC-Rio.
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

set(LUA_HEADERS
  lua.h
  luaconf.h
  lualib.h
  lauxlib.h
  lua.hpp
)

set(LUA_CORE_SOURCE_FILES
  lapi.c
  lcode.c
  lctype.c
  ldebug.c
  ldo.c
  ldump.c
  lfunc.c
  lgc.c
  llex.c
  lmem.c
  lobject.c
  lopcodes.c
  lparser.c
  lstate.c
  lstring.c
  ltable.c
  ltm.c
  lundump.c
  lvm.c
  lzio.c
)

set(LUA_LIB_SOURCE_FILES
  lauxlib.c
  lbaselib.c
  lbitlib.c
  lcorolib.c
  ldblib.c
  liolib.c
  lmathlib.c
  loslib.c
  lstrlib.c
  ltablib.c
  lutf8lib.c
  loadlib.c
  linit.c
)

set(LUA_SOURCE_FILES
  ${LUA_CORE_SOURCE_FILES}
  ${LUA_LIB_SOURCE_FILES}
  ${LUA_HEADERS}
)

install(FILES ${LUA_HEADERS} DESTINATION include)

# Lua library
add_library(lua ${LUA_SOURCE_FILES})
set_property(TARGET lua PROPERTY INTERFACE_INCLUDE_DIRECTORIES
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
)
set_target_properties(lua PROPERTIES VERSION "${lua_VERSION}")
set_target_properties(lua PROPERTIES SOVERSION "${lua_VERSION}")

install(
  TARGETS lua
  EXPORT lua-lib-targets
  RUNTIME DESTINATION ${LUA_INSTALL_BIN_DIR}
  LIBRARY DESTINATION ${LUA_INSTALL_LIB_DIR}
  ARCHIVE DESTINATION ${LUA_INSTALL_LIB_DIR}
)
install(
  EXPORT lua-lib-targets
  NAMESPACE lua::
  DESTINATION ${LUA_INSTALL_CMAKE_DIR}
  EXPORT_LINK_INTERFACE_LIBRARIES
)

# Lua compiler
if(BUILD_LUA_COMPILER)
  add_executable(luac luac.c)
  target_link_libraries(luac lua ${LUA_EXTERNAL_LIBS})

  install(
    TARGETS luac
    EXPORT lua-compiler-targets
    RUNTIME DESTINATION ${LUA_INSTALL_BIN_DIR}
  )
  install(
    EXPORT lua-compiler-targets
    NAMESPACE lua::
    DESTINATION ${LUA_INSTALL_CMAKE_DIR}
    EXPORT_LINK_INTERFACE_LIBRARIES
  )
endif()

# Lua interpreter
if(BUILD_LUA_INTERPRETER)
  add_executable(luai lua.c)
  set_target_properties(luai PROPERTIES OUTPUT_NAME lua)
  target_link_libraries(luai lua ${LUA_EXTERNAL_LIBS})

  install(
    TARGETS luai
    EXPORT lua-interpreter-targets
    RUNTIME DESTINATION ${LUA_INSTALL_BIN_DIR}
  )
  install(
    EXPORT lua-interpreter-targets
    NAMESPACE lua::
    DESTINATION ${LUA_INSTALL_CMAKE_DIR}
    EXPORT_LINK_INTERFACE_LIBRARIES
  )
endif()
