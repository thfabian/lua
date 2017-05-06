# - Find libdl
# Find the native LIBDL includes and library
#
# Usage of this module as follows:
#
#     find_package(Readline)
#
# Variables defined by this module:
#
#  LIBDL_INCLUDE_DIR - where to find dlfcn.h, etc.
#  LIBDL_LIBRARIES   - List of libraries when using libdl.
#  LIBDL_FOUND       - True if libdl found.

include(FindPackageHandleStandardArgs)

# Already in cache, be silent
if(LIBDL_INCLUDE_DIR)
  set(LIBDL_FIND_QUIETLY TRUE)
endif()

find_path(LIBDL_INCLUDE_DIR dlfcn.h)

set(LIBDL_NAMES dl libdl ltdl libltdl)
find_library(LIBDL_LIBRARY NAMES ${LIBDL_NAMES} )

find_package_handle_standard_args(LibDL DEFAULT_MSG LIBDL_LIBRARY LIBDL_INCLUDE_DIR)

if(LIBDL_FOUND)
  set(LIBDL_LIBRARIES ${LIBDL_LIBRARY})
else()
  set(LIBDL_LIBRARIES)
endif()

mark_as_advanced(LIBDL_LIBRARY LIBDL_INCLUDE_DIR)
