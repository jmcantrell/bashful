#include "1459669815-tmp/gpp-profile_verify.sh"
#include "1459669815-tmp/gpp-profile_variables_required.sh"
#include "1459669815-tmp/gpp-profile_variables.sh"
#include "1459669815-tmp/gpp-profile_hook.sh"
#include "1459669815-tmp/gpp-profile_clear.sh"
#include "1459669815-tmp/gpp-error.sh"
#ifndeff PROFILE_LOAD
#define PROFILE_LOAD
profile_load() #{{{1
{
    # <doc:profile_load> {{{
    #
    # Load a profile.
    #
    # If a profile default is set, any missing settings will fallback to it.
    # Any previous profile settings will be cleared first based on what is
    # defined in the default profile. This is to be sure that you're not using
    # settings from different profiles.
    #
    # The uncommented default profile settings are considered required, and
    # uncommented settings are considered optional.
    #
    # </doc:profile_load> }}}

    profile_verify || return 1

    profile_hook load pre

    profile_clear

    eval "$PROFILE_DEFAULT"; source $PROFILE_FILE

    # If any required setting is unset, you're getting an error.
    local var
    for var in $(profile_variables_required); do
        if [[ ! ${!var} ]]; then
            error "Variable '$var' is not set for profile '$profile'."
            return 1
        fi
    done

    export PROFILE
    for var in $(profile_variables); do
        export $var
    done

    profile_hook load post
}
#endif
#ifndeff PROFILE_LOAD
#define PROFILE_LOAD
profile_load() #{{{1
{
    # <doc:profile_load> {{{
    #
    # Load a profile.
    #
    # If a profile default is set, any missing settings will fallback to it.
    # Any previous profile settings will be cleared first based on what is
    # defined in the default profile. This is to be sure that you're not using
    # settings from different profiles.
    #
    # The uncommented default profile settings are considered required, and
    # uncommented settings are considered optional.
    #
    # </doc:profile_load> }}}

    profile_verify || return 1

    profile_hook load pre

    profile_clear

    eval "$PROFILE_DEFAULT"; source $PROFILE_FILE

    # If any required setting is unset, you're getting an error.
    local var
    for var in $(profile_variables_required); do
        if [[ ! ${!var} ]]; then
            error "Variable '$var' is not set for profile '$profile'."
            return 1
        fi
    done

    export PROFILE
    for var in $(profile_variables); do
        export $var
    done

    profile_hook load post
}
#endif
