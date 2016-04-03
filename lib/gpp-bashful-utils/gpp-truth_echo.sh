#include "./lib/gpp-bashful-utils/gpp-truth.sh"
#ifndeff TRUTH_ECHO
#define TRUTH_ECHO
truth_echo() #{{{1
{
    # <doc:truth_echo> {{{
    #
    # Depending on the "truthiness" of the given value, echo the first (true)
    # or second (false) value.
    #
    # </doc:truth_echo> }}}

    if truth "$1"; then
        [[ $2 ]] && echo "$2"
    else
        [[ $3 ]] && echo "$3"
    fi
}
#endif
