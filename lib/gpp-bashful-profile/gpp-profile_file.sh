#include "./lib/gpp-bashful-profile/gpp-profile_choose.sh"
#include "./lib/gpp-bashful-profile/gpp-error.sh"
#ifndeff PROFILE_FILE
#define PROFILE_FILE
profile_file() #{{{1
{
    # <doc:profile_file> {{{
    #
    # Make sure the profile file is set before continuing.
    #
    # </doc:profile_file> }}}

    if [[ ! $PROFILE ]]; then
        PROFILE=$(profile_choose) || return 1
    fi

    if [[ ! $PROFILE ]]; then
        error "Profile not provided."
        return 1
    fi

    PROFILE_FILE=$PROFILE_DIR/$PROFILE
}
#endif
