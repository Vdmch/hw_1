################################
# GTest
################################

set(test_files test_func.cpp)

enable_testing()
find_package(GTest REQUIRED)
find_package(Threads REQUIRED)


include_directories(${GTEST_INCLUDE_DIRS})
add_library(test_lib STATIC ${lib_files})

# Добавление тестов с санитайзерами undefined, leak и address
add_executable(runUnitTests ${test_files})
target_link_libraries(runUnitTests ${GTEST_LIBRARIES} test_lib pthread gcov)
target_compile_options(runUnitTests PRIVATE -O0 -g)
target_link_options(runUnitTests PRIVATE -static-libasan -fsanitize=undefined -fsanitize=leak -fsanitize=address)
add_test(runUnitTests runUnitTests)

# Добавление тестов с санитайзером thread
add_executable(runUnitTests_thread ${test_files})
target_link_libraries(runUnitTests_thread ${GTEST_LIBRARIES} test_lib pthread gcov)
target_compile_options(runUnitTests_thread PRIVATE -fprofile-arcs -O0 -g)
target_link_options(runUnitTests_thread PRIVATE -static-libasan -fsanitize=thread)
add_test(runUnitTests_thread runUnitTests_thread)

# Добавление тестов с санитайзером valgrind
add_executable(runUnitTests_valgrind ${test_files})
target_link_libraries(runUnitTests_valgrind ${GTEST_LIBRARIES} test_lib pthread)
target_compile_options(runUnitTests_valgrind PRIVATE -O0 -g)
add_test(runUnitTests_valgrind runUnitTests_valgrind)
