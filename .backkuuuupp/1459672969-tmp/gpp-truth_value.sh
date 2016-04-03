#include "gpp-truth_echo.sh"
#ifndeff TRUTH_VALUE
#define TRUTH_VALUE
truth_value() #{{{1
{
    # <doc:truth_value> {{{
    #
    # Gets a value that represents the "truthiness" of the given value.
    #
    # </doc:truth_value> }}}

    truth_echo "$1" 1 0
}
#endif
