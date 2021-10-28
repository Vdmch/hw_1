file(
        GLOB ALL_SOURCE_FILES 
        src/main.c 
        lib/users/src/users.c 
        lib/users/include/users.h
)

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
        -p ./
        ${ALL_SOURCE_FILES}
        --checks=-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling
        COMMAND echo  done: clang-tidy
        
#        COMMAND echo ---------------------------------------- cpplint ---------------------------------------
#        COMMAND python3 -m cpplint
#        ${ALL_SOURCE_FILES}
)
