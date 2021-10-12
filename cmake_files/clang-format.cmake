file(GLOB ALL_SOURCE_FILES ${progr_files})

add_custom_target(
        clangformat
        COMMAND clang-format
        -style=Google 
        -i
        ${ALL_SOURCE_FILES}
)