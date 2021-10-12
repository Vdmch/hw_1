file(GLOB ALL_SOURCE_FILES ${progr_files} ${lib_files})

add_custom_target(
        cppcheck
        COMMAND /usr/bin/cppcheck
#        --enable=warning,performance,portability,information,missingInclude
        --language=c
        --inconclusive
        --enable=all
#        --verbose
#        --quiet
#        --check-config
#        --template="[{severity}][{id}] {message} {callstack} \(On {file}:{line}\)"
        ${ALL_SOURCE_FILES}
)