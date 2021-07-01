set(ALGLIB_DIRECTORY /usr/local/include/alglib/src)

include_directories(${ALGLIB_DIRECTORY})

file(GLOB ALGLIB_HEADERS "${ALGLIB_DIRECTORY}/*.h")
file(GLOB ALGLIB_SOURCE "${ALGLIB_DIRECTORY}/*.cpp")

set(KLEE_DIRECTORY /Users/ishaangandhi/dist/klee/include)

include_directories(${KLEE_DIRECTORY})

file(GLOB KLEE_HEADERS "${KLEE_DIRECTORY}/*.h")
file(GLOB KLEE_SOURCE "${KLEE_DIRECTORY}/*.cpp")

add_llvm_library( LLVMInterp MODULE
  Interp.cpp
  hello.c
  ${ALGLIB_HEADERS}
  ${ALGLIB_SOURCE}
  PLUGIN_TOOL
  opt
  )

