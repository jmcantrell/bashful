#include "lib/tmp/gpp-profile_list.sh"
#include "lib/tmp/gpp-error.sh"
#include "lib/tmp/gpp-choice.sh"
#ifndeff PROFILE_CHOOSE
#define PROFILE_CHOOSE
profile_choose() #{{{1
{
    # <doc:profile_choose> {{{
    #
    # Prompt user for a profile.
    #
    # If interactive mode is not enabled, you better have already set the
    # profile or it's errors for everyone.
    #
    # </doc:profile_choose> }}}

    if (( $(profile_list | wc -l) == 0 )); then
        error "No profiles available."
        return 0
    fi

    local OIFS=$IFS; local IFS=$'\n'
    local profiles=($(profile_list))
    IFS=$OIFS

    local choice=$(choice -c -p "Choose profile" "${profiles[@]}")

    if [[ $choice ]]; then
        echo "$choice"
    else
        error "Profile not provided."
        return 1
    fi
}
#endif
