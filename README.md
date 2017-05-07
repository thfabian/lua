# Lua 5.3.4

This repository adds CMake and CI support for Lua. For installation instructions, license details, and further information about Lua, see doc/readme.html.

## Build

To build Lua with CMake
```C++
  mkdir build
  cd build
  cmake .. 
  camke --build .
```
which will setup CMake with your default build-system (e.g Make on Linux) and build it.

## Continuous integration  <a id="continuous-integration"></a>

|    OS   |  Status                                                                                                     |
|:------- |:-----------------------------------------------------------------------------------------------------------:|
| Mac OSX | [![Build Status](https://travis-ci.org/thfabian/lua.svg?branch=master)](https://travis-ci.org/thfabian/lua) | 
| Linux   | [![Build Status](https://travis-ci.org/thfabian/lua.svg?branch=master)](https://travis-ci.org/thfabian/lua) |
