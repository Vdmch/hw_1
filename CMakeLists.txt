cmake_minimum_required(VERSION 3.14)
project(basic_test)

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_C_STANDARD 11)

set(CXX_COMPILER_FLAGS, "${CMAKE_CXX_FLAGS} -Wall -fprofile-arcs -ftest-coverage")
set(C_COMPILER_FLAGS, "${CMAKE_C_FLAGS} -Wall -fprofile-arcs -ftest-coverage")

set(progr_files main.c main.h) 
set(lib_files users.c users.h) 

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    include(cmake_files/analysers.cmake)
    include (cmake_files/tests.cmake)
endif()

add_executable(main ${progr_files})

add_library(lib  ${lib_files})
target_link_libraries(main lib)

