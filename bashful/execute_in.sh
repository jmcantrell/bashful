#include "execute.sh"
#include "error.sh"
#ifndef EXECUTE_IN
#define EXECUTE_IN
execute_in() #{{{1
{
    # <doc:execute_in> {{{
    #
    # Execute a command in a given directory.
    #
    # Usage: execute_in DIRECTORY [COMMAND...]
    #
    # </doc:execute_in> }}}

    local OPWD=$PWD; cd "$1"; shift
    execute "$@"; error=$?
    cd "$OPWD"
    return $error
}
#endif
