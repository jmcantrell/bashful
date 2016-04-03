#include "1459670344-tmp/gpp-error.sh"
#ifndeff PROFILE_INIT
#define PROFILE_INIT
profile_init() #{{{1
{
    # <doc:profile_init> {{{
    #
    # Initialize the profile environment.
    #
    # This function should be called in the script before any other
    # functionality is used. If prefix was set, use that.
    # Otherwise use a prefix appropriate for the user's permissions.
    #
    # </doc:profile_init> }}}

    if (( EUID == 0 )); then
        PREFIX=${PREFIX:-/usr/local}
    else
        PREFIX=${PREFIX:-$HOME}
    fi

    # If profile name isn't set, default to script name.
    PROFILE_NAME=${PROFILE_NAME:-$SCRIPT_NAME}

    # If neither was set, you're doing it wrong.
    if [[ ! $PROFILE_NAME ]]; then
        error "PROFILE_NAME/SCRIPT_NAME not set."
        return 1
    fi

    # Depending on whether or not we have root privileges,
    # the config directory will be in $HOME or /usr/local/etc
    if [[ ! $CONFIG_DIR ]]; then
        if [[ ${PREFIX%%/} == $HOME ]]; then
            CONFIG_DIR=$PREFIX/.$PROFILE_NAME
        else
            CONFIG_DIR=$PREFIX/etc/$PROFILE_NAME
        fi
    fi

    PROFILE_DIR=$CONFIG_DIR/profiles
}
#endif
