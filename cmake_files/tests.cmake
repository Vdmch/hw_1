################################
# GTest
################################

set(test_files test_func.cpp)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread  -static-libtsan")
set (CMAKE_CXX_STANDARD 17)

# Добавление файлов googletest
set(GOOGLETEST_ROOT googletest/googletest CACHE STRING "Google Test source root")
include_directories(SYSTEM
    ${PROJECT_SOURCE_DIR}/${GOOGLETEST_ROOT}
    ${PROJECT_SOURCE_DIR}/${GOOGLETEST_ROOT}/include
    )

set(GOOGLETEST_SOURCES
    ${PROJECT_SOURCE_DIR}/${GOOGLETEST_ROOT}/src/gtest-all.cc
    ${PROJECT_SOURCE_DIR}/${GOOGLETEST_ROOT}/src/gtest_main.cc
    )

foreach(_source ${GOOGLETEST_SOURCES})
    set_source_files_properties(${_source} PROPERTIES GENERATED 1)
endforeach()

enable_testing()



add_library(test_lib  ${lib_files})
add_library(googletest ${GOOGLETEST_SOURCES})



# Добавление тестов с санитайзерами undefined, leak и address
add_executable(runUnitTests ${test_files})

set(TEST0_CXX_COMPILER_FLAGS, "${CMAKE_CXX_FLAGS} -fsanitize=undefined -fsanitize=leak -fsanitize=address -O0 -g")
set(TEST0_C_COMPILER_FLAGS, "${CMAKE_C_FLAGS} -fsanitize=undefined -fsanitize=leak -fsanitize=address -O0 -g")

target_compile_options(runUnitTests PRIVATE 
    $<$<COMPILE_LANGUAGE:CXX>: ${TEST0_CXX_COMPILER_FLAGS}> 
    $<$<COMPILE_LANGUAGE:C>: ${TEST0_C_COMPILER_FLAGS}>
)

target_link_libraries(runUnitTests googletest)
target_link_libraries(runUnitTests test_lib)
add_test(runUnitTests runUnitTests)




# Добавление тестов с санитайзером thread
add_executable(runUnitTests_thread ${test_files})

set(TEST1_CXX_COMPILER_FLAGS, "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage -fsanitize=thread -O0 -g")
set(TEST1_C_COMPILER_FLAGS, "${CMAKE_C_FLAGS} -fprofile-arcs -ftest-coverage -fsanitize=thread -O0 -g")

target_compile_options(runUnitTests_thread PRIVATE 
    $<$<COMPILE_LANGUAGE:CXX>: ${TEST1_CXX_COMPILER_FLAGS}> 
    $<$<COMPILE_LANGUAGE:C>: ${TEST1_C_COMPILER_FLAGS}>
    )

target_link_libraries(runUnitTests_thread test_lib)
target_link_libraries(runUnitTests_thread googletest)
add_test(runUnitTests_thread runUnitTests_thread)

