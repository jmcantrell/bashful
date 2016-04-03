#include "lib/tmp/gpp-verbose.sh"
#include "lib/tmp/gpp-execute_in.sh"
#ifndeff VERBOSE_EXECUTE_IN
#define VERBOSE_EXECUTE_IN
verbose_execute_in() #{{{1
{
    # <doc:verbose_execute_in> {{{
    #
    # Will execute the given command in the given directory and only display
    # the output if verbose mode is enabled.
    #
    # Usage: verbose_execute_in DIRECTORY [COMMAND]
    #
    # </doc:verbose_execute_in> }}}

    if verbose; then
        execute_in "$@"
    else
        execute_in "$@" &>/dev/null
    fi
}
#endif
