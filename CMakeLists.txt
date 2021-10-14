cmake_minimum_required(VERSION 3.14)
project(basic_test)

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_C_STANDARD 11)

set(progr_files src/main.c src/main.h) 
set(lib_files src/users.c src/users.h) 

if(CMAKE_BUILD_TYPE STREQUAL "Debug") 
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")
    include(cmake_files/analysers.cmake)
    include (cmake_files/tests.cmake)
endif()

add_executable(main ${progr_files})

add_library(lib  ${lib_files})
target_link_libraries(main lib)

