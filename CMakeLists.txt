cmake_minimum_required(VERSION 3.14)
project(basic_test)

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_C_STANDARD 11)

add_compile_options(-Wall -Wextra -pedantic)

option(WITH_COVERAGE "Add coverage estimation")
if(WITH_COVERAGE)
    include(cmake_files/coverage.cmake)
    add_compile_options(--coverage)
    add_link_options(--coverage)
endif()

option(WITH_TESTS "Build tests" ON)
if(WITH_TESTS OR WITH_SANITIZERS OR WITH_COVERAGE)
    include(cmake_files/analysers.cmake)
    find_package(GTest REQUIRED)
    enable_testing()
    set(BUILD_TESTS ON)
endif()

add_subdirectory(lib/users)

add_executable(main src/main.c)
target_link_libraries(main users)
