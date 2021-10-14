################################
# GTest
################################

set(test_files test_func.cpp)

find_package(GTest REQUIRED)
enable_testing()

add_library(test_lib STATIC ${lib_files})

# Добавление тестов с санитайзерами undefined, leak и address
add_executable(runUnitTests ${test_files})
target_link_libraries(runUnitTests GTest::Main test_lib pthread)
target_compile_options(runUnitTests PRIVATE -O0 -g -static-libasan -fsanitize=undefined -fsanitize=leak -fsanitize=address)
target_link_options(runUnitTests PRIVATE -static-libasan -fsanitize=undefined -fsanitize=leak -fsanitize=address)
add_test(runUnitTests runUnitTests)

# Добавление тестов с санитайзером thread
add_executable(runUnitTests_thread ${test_files})
target_link_libraries(runUnitTests_thread GTest::Main test_lib pthread)
target_compile_options(runUnitTests_thread PRIVATE -O0 -g -static-libasan -fsanitize=thread)
target_link_options(runUnitTests_thread PRIVATE -static-libasan -fsanitize=thread)
add_test(runUnitTests_thread runUnitTests_thread)

# Добавление тестов с санитайзером valgrind
add_executable(runUnitTests_valgrind ${test_files})

target_link_libraries(runUnitTests_valgrind GTest::Main test_lib pthread gcov)
target_link_libraries(test_lib GTest::Main pthread gcov)

target_compile_options(runUnitTests_valgrind PRIVATE -O0 -g)

add_test(runUnitTests_valgrind runUnitTests_valgrind)
