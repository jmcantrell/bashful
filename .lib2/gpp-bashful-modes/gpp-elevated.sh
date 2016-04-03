#include "1459670344-tmp/gpp-truth_value.sh"
#include "1459670344-tmp/gpp-truth_echo.sh"
#include "1459670344-tmp/gpp-truth.sh"
#ifndeff ELEVATED
#define ELEVATED
elevated() #{{{1
{
    # <doc:elevated> {{{
    #
    # With no arguments, test if elevated mode is enabled.
    # With one argument, set elevated mode to given value.
    #
    # Usage: elevated [VALUE]
    #
    # </doc:elevated> }}}

    if (( $# == 0 )); then
        truth $ELEVATED && return 0
        return 1
    fi

    export ELEVATED=$(truth_value $1)
    export SUDO=$(truth_echo "$ELEVATED" sudo)
}
#endif
