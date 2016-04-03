#include "gpp-variables.sh"
#ifndef PROFILE_VARIABLES_REQUIRED
#define PROFILE_VARIABLES_REQUIRED
profile_variables_required() #{{{1
{
    # <doc:profile_variables_required> {{{
    #
    # List all required variables available to a profile (set or not).
    #
    # </doc:profile_variables_required> }}}

    grep -v '^[[:space:]]*#' <<<"$PROFILE_DEFAULT" | variables
}
#endif
