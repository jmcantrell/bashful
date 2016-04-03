#include "lib/tmp/gpp-truth_echo.sh"
#ifndeff VERBOSE_ECHO
#define VERBOSE_ECHO
verbose_echo() #{{{1
{
    # <doc:verbose_echo> {{{
    #
    # Will only echo the first argument if verbose mode is enabled.
    # Otherwise, echo the second argument.
    #
    # Usage: verbose_echo [TRUE_VALUE] [FALSE_VALUE]
    #
    # </doc:verbose_echo> }}}

    truth_echo "$VERBOSE" "$1" "$2"
}
#endif
