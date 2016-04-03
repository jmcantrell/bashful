#include "gpp-variables.sh"
#ifndef PROFILE_VARIABLES
#define PROFILE_VARIABLES
profile_variables() #{{{1
{
    # <doc:profile_variables> {{{
    #
    # List all variables available to a profile (set or not).
    #
    # </doc:profile_variables> }}}

    variables <<<"$PROFILE_DEFAULT"
}
#endif
