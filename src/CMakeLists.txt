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
install(TARGETS liblua 
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)
        
# Lua compiler
if(BUILD_LUA_COMPILER)
  if(WIN32 AND BUILD_SHARED_LIBS)
    add_executable(luac ${sources} luac.c)
  else()
    add_executable(luac luac.c)
    target_link_libraries(luac liblua ${LUA_EXTERNAL_LIBS})
  endif()
  
  install(TARGETS luac RUNTIME DESTINATION bin)
endif()

# Lua interpreter
if(BUILD_LUA_INTERPRETER)
  if(WIN32 AND BUILD_SHARED_LIBS)
    add_executable(lua ${sources} lua.c)
  else()
    add_executable(lua lua.c)
    target_link_libraries(lua liblua ${LUA_EXTERNAL_LIBS})
  endif()  
  install(TARGETS lua RUNTIME DESTINATION bin)
endif()