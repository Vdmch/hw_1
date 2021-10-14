file(GLOB ALL_SOURCE_FILES ${progr_files} ${lib_files})
add_custom_target(
        analysers
        
        COMMAND echo ------------------------------------- clang-format -------------------------------------
        COMMAND clang-format
        -style=Google 
        -i
        ${ALL_SOURCE_FILES}
        COMMAND echo  done: clang-format

        COMMAND echo --------------------------------------- cppcheck ---------------------------------------
        COMMAND cppcheck
        --language=c
        --inconclusive
        --enable=all
        ${ALL_SOURCE_FILES}
        COMMAND echo  done: cppcheck

        COMMAND echo -------------------------------------- clang-tidy --------------------------------------
        COMMAND clang-tidy
        ${ALL_SOURCE_FILES}
        --checks=-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling
        --
        COMMAND echo  done: clang-tidy
        
#        COMMAND python3 -m cpplint
#        ${ALL_SOURCE_FILES}
)

add_custom_target(
        coverage
        COMMAND mkdir
        ./coverage

        COMMAND gcovr
        -r ../
        -f ../src/
        --html --html-details
        -o ./coverage/details.html
)