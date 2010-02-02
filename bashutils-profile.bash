#!/bin/bash

# Filename:      bashutils-profile.sh
# Description:   Utilities for using script profiles.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-02-01 21:46:30 (-0500)

# DOCUMENTATION {{{1
#
# There are some pieces of info needed for profile to work well.  The most
# important being the name of the app using it. This is provided by setting
# either PROFILE_NAME or SCRIPT_NAME. If PROFILE_NAME is set, it will be
# preferred over SCRIPT_NAME. Technically this is the only variable that is
# required to function.
#
# If you intend to write new profiles with your script, a default profile
# should be provided with the PROFILE_DEFAULT variable like this:
#
#     PROFILE_DEFAULT="
#     do_some_action=1
#     my_name='Jim Generic'
#     some_array=(this is an array)
#     # some_optional_var=foo
#     "
#
# Any new profile will be given these values for you to change, and any
# profile that does not specify a value for a particular variable will inherit
# the value from the default profile. Uncommented variables are considered to
# be required and is considered an error if any profile does not provide it.
# Any commented variables are considered optional and will not be subject to
# this check.
#
# You can override the default config directory by setting CONFIG_DIR.
# Otherwise, this value will be set to one of the following:
#
#     Run as user:    ~/.$SCRIPT_NAME
#     Run as root:    /usr/local/etc/$SCRIPT_NAME
#     PREFIX is set:  $PREFIX/$SCRIPT_NAME
#
# In summary, before any functionality can be used, you must do the following:
#
#     source bashutils-profile
#
#     PROFILE_NAME=myapp
#     PROFILE_DEFAULT="..."
#
#     profile_init  # This will return non-zero exit code on error.
#
#}}}1

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_PROFILE_LOADED ]] && return

source bashutils-files
source bashutils-input
source bashutils-messages
source bashutils-modes
source bashutils-utils

profile_actions() #{{{1
{
    declare -F |
    awk '{print $NF}' |
    grep '^profile_' |
    sed 's/^profile_//' |
    sort
}

profile_choose() #{{{1
{
    # Prompt user for a profile.
    # If interactive mode is not enabled, you better have already set the
    # profile or it's errors for everyone.

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

profile_clear() #{{{1
{
    local var
    for var in $(profile_variables); do
        unset $var
    done
}

profile_create() #{{{1
{
    [[ $PROFILE ]] || PROFILE=$(input -c -p "Enter profile")

    profile_file || return 1

    mkdir -p "$PROFILE_DIR"

    if [[ -f $PROFILE_FILE ]]; then
        error "Profile '$PROFILE' already exists."
        return 1
    fi

    info -c "Creating new profile '$PROFILE'..."

    squeeze_lines <<<"$PROFILE_DEFAULT" >$PROFILE_FILE

    if interactive; then
        editor "$PROFILE_FILE"
    else
        warn -c "Profile '$PROFILE_FILE' may need to be modified."
    fi
}

profile_delete() #{{{1
{
    profile_verify || return 1
    question -c -p "Are you sure you want to delete '$PROFILE'?" || return 1
    info -c "Deleting profile '$PROFILE'..."
    rm -f "$PROFILE_FILE"
}

profile_edit() #{{{1
{
    profile_verify || return 1
    editor "$PROFILE_FILE"
}

profile_file() #{{{1
{
    # Make sure the profile file is set before continuing.

    if [[ ! $PROFILE ]]; then
        PROFILE=$(profile_choose) || return 1
    fi

    if [[ ! $PROFILE ]]; then
        error "Profile not provided."
        return 1
    fi

    PROFILE_FILE=$PROFILE_DIR/$PROFILE
}

profile_init() #{{{1
{
    # This function should be called in the script before any other
    # functionality is used.

    # If prefix was set, use that.
    # Otherwise use a prefix appropriate for the user's permissions.
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

profile_list() #{{{1
{
    listdir "$PROFILE_DIR" -type f |
    awk -F'/' '{print $NF}' |
    grep -v '^\.' |
    grep "${PROFILE:+^$PROFILE$}" |
    sort
}

profile_load() #{{{1
{
    # Load a profile.
    #
    # If a profile default is set, any missing settings will fallback to it.
    # Any previous profile settings will be cleared first based on what is
    # defined in the default profile. This is to be sure that you're not using
    # settings from different profiles.
    #
    # The uncommented default profile settings are considered required, and
    # uncommented settings are considered optional.

    profile_verify || return 1

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
}

profile_variables() #{{{1
{
    variables <<<"$PROFILE_DEFAULT"
}

profile_variables_required() #{{{1
{
    grep -v '^[[:space:]]*#' <<<"$PROFILE_DEFAULT" | variables
}

profile_verify() #{{{1
{
    # Make sure the profile file exists before continuing.

    profile_file || return 1

    if [[ ! -f $PROFILE_FILE ]]; then
        error "Profile '$PROFILE' does not exist or not a regular file."
        return 1
    fi
}

#}}}1

BASHUTILS_PROFILE_LOADED=1
