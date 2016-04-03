#include "verbose.sh"
#include "execute.sh"
#ifndef VERBOSE_EXECUTE
#define VERBOSE_EXECUTE
verbose_execute() #{{{1
{
    # <doc:verbose_execute> {{{
    #
    # Will execute the given command and only display the output if verbose
    # mode is enabled.
    #
    # Usage: verbose_execute [COMMAND]
    #
    # </doc:verbose_execute> }}}

    if verbose; then
        execute "$@"
    else
        execute "$@" &>/dev/null
    fi
}
#endif
