#include "gpp-truth_echo.sh"
#ifndef INTERACTIVE_ECHO
#define INTERACTIVE_ECHO
interactive_echo() #{{{1
{
    # <doc:interactive_echo> {{{
    #
    # Will only echo the first argument if interactive mode is enabled.
    # Otherwise, echo the second argument.
    #
    # Usage: interactive_echo [TRUE_VALUE] [FALSE_VALUE]
    #
    # </doc:interactive_echo> }}}

    truth_echo "$INTERACTIVE" "$1" "$2"
}
#endif
