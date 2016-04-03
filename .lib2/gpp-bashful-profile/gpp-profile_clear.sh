#include "1459670344-tmp/gpp-profile_variables.sh"
#ifndeff PROFILE_CLEAR
#define PROFILE_CLEAR
profile_clear() #{{{1
{
    # <doc:profile_clear> {{{
    #
    # Unsets all variables from a profile.
    #
    # </doc:profile_clear> }}}

    local var
    for var in $(profile_variables); do
        unset $var
    done
    if [[ $PROFILE_VARIABLES ]]; then
        for var in "${PROFILE_VARIABLES[@]}"; do
            unset $var
        done
    fi
}
#endif
