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

set(sources
  # core 
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
  
  # lib
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

set(install_sources 
  lua.h 
  luaconf.h 
  lualib.h 
  lauxlib.h 
  lua.hpp
)
install(FILES ${install_sources} DESTINATION include)

add_library(lua_objects OBJECT ${sources})

# Lua library
add_library(liblua $<TARGET_OBJECTS:lua_objects>)
set_target_properties(liblua PROPERTIES OUTPUT_NAME lua)
set_target_properties(liblua PROPERTIES VERSION "${LUA_VERSION}")
set_target_properties(liblua PROPERTIES SOVERSION "${LUA_VERSION}")

install(
  TARGETS liblua 
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
  if(WIN32 AND BUILD_SHARED_LIBS)
    add_executable(luac ${sources} luac.c)
  else()
    add_executable(luac luac.c $<TARGET_OBJECTS:lua_objects>)
    target_link_libraries(luac ${LUA_EXTERNAL_LIBS})
  endif()
  
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
  if(WIN32 AND BUILD_SHARED_LIBS)
    add_executable(lua ${sources} lua.c)
  else()
    add_executable(lua lua.c $<TARGET_OBJECTS:lua_objects>)
    target_link_libraries(lua ${LUA_EXTERNAL_LIBS})
  endif()  

  install(
    TARGETS lua 
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
