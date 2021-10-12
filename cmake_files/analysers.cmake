file(GLOB ALL_SOURCE_FILES ${progr_files} ${lib_files})

add_custom_target(
        analysers
        
        COMMAND clang-format
        -style=Google 
        -i
        ${ALL_SOURCE_FILES}

        COMMAND echo --------------------------- cppcheck ---------------------------
        COMMAND cppcheck
        --language=c
        --inconclusive
        --enable=all
        ${ALL_SOURCE_FILES}

        COMMAND echo --------------------------- clang-tidy ---------------------------
        COMMAND clang-tidy
        ${ALL_SOURCE_FILES}
        
#        COMMAND echo --------------------------- cpplint ---------------------------
#        COMMAND python3 -m cpplint
#        ${ALL_SOURCE_FILES}

        COMMAND echo --------------------------- scan-build ---------------------------
        COMMAND scan-build
        make main
)
