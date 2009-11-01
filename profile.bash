#!/bin/bash

# Filename:      profile.bash
# Description:   Manages script profiles.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Sat 2009-10-31 21:49:53 (-0400)

. interaction
. messages
. modes
. utils

# DOCUMENTATION {{{1
#
# There are some pieces of info needed for profile to work well.  The most
# important being the name of the app using it. This can be provided on the
# command line with -N or with an exported environment variable PROFILE_NAME.
# Technically this is the only variable that is required to function.
#
# If you intend to write new profiles with your script, a default profile
# should be provided with the exported PROFILE_DEFAULT variable like this:
#
#     export PROFILE_DEFAULT="
#     do_some_action=1
#     my_name='Jim Generic'
#     some_array=(this is an array)
#     "
#
# Any new profile will be given these values for you to change, and any
# profile that does not specify a value for a particular variable will inherit
# the value from the default profile.
#
# You can override the default config directory with the -C option or by
# exporting a value for CONFIG_DIR. Other variable can be overriden, such as
# EDITOR, which is used to pull up a profile.
#
# You can query a specific value from a profile by doing the following:
#
#     profile -N myapp -P theprofile -V thevariable view
#
# If you want to inherit the default config directory used for profile for
# your script, you can do this (assuming you have exported PROFILE_NAME):
#
#     CONFIG_DIR=$(profile -V CONFIG_DIR view)

# FUNCTIONS {{{1

variables() #{{{2
{
    sed 's/[[:space:];]/\n/g' |
    egrep '^[a-zA-Z0-9_]+=' |
    awk -F= '{print $1}'
}

profile_file() #{{{2
{
    if [[ ! $PROFILE ]]; then
        PROFILE=$(profile_choose) || return 1
    fi

    if [[ ! $PROFILE ]]; then
        error "Profile not provided."
        return 1
    fi

    profile_file=$PROFILE_DIR/$PROFILE
}

profile_verify() #{{{2
{
    profile_file || return 1

    if [[ ! -f $profile_file ]]; then
        error "Profile '$PROFILE' does not exist or not a regular file."
        return 1
    fi
}

profile_choose() #{{{2
{
    if (( $(profile_list | wc -l) == 0 )); then
        error "No profiles available."
        return 0
    fi

    OIFS=$IFS; IFS=$'\n'
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

profile_load() #{{{2
{
    profile_verify || return 1

    profile_clear

    echo -e "$PROFILE_DEFAULT\n$(<$profile_file)" | grep -v '^[[:space:]]*#'
}

profile_clear() #{{{2
{
    profile_variables | sed 's/$/=/'
}

profile_variables() #{{{2
{
    variables <<<"$PROFILE_DEFAULT"
}

profile_variables_required() #{{{2
{
    grep -v '^[[:space:]]*#' <<<"$PROFILE_DEFAULT" | variables
}

profile_delete() #{{{2
{
    profile_verify || return 1

    question -c -p "Are you sure you want to delete '$PROFILE'?" || return 1
    info -c "Deleting profile '$PROFILE'..."

    rm -f "$profile_file"
}

profile_list() #{{{2
{
    find "$PROFILE_DIR" -mindepth 1 -maxdepth 1 -type f 2>/dev/null |
    awk -F'/' '{print $NF}' |
    grep -v '^\.' |
    grep "${PROFILE:+^$PROFILE$}" |
    sort
}

profile_create() #{{{2
{
    [[ $PROFILE ]] || PROFILE=$(input -c -p "Enter profile")

    profile_file || return 1

    mkdir -p "$PROFILE_DIR"

    if [[ -f $profile_file ]]; then
        error "Profile '$PROFILE' already exists."
        return 1
    fi

    info -c "Creating new profile '$PROFILE'..."

    squeeze_lines "$PROFILE_DEFAULT" >$profile_file

    if interactive; then
        $EDITOR "$profile_file"
    else
        warn -c "Profile '$profile_file' may need to be modified."
    fi
}

profile_edit() #{{{2
{
    profile_verify || return 1
    $EDITOR "$profile_file"
}

profile_view() #{{{2
{
    [[ $PROFILE ]] && eval "$(profile_load)"
    echo "${!VARIABLE}"
}

profile_actions() #{{{2
{
    declare -F |
    awk '{print $NF}' |
    grep '^profile_' |
    sed 's/^profile_//' |
    sort
}

# VARIABLES {{{1

SCRIPT_NAME=$(basename "$0" .bash)
SCRIPT_ARGS="[ACTION]"
SCRIPT_USAGE="Manages script configuration and profiles."
SCRIPT_OPTIONS="
-C DIRECTORY    Use DIRECTORY for configuration.

-N NAME         Use NAME for script name.
-P PROFILE      Use PROFILE for action.
-V VARIABLE     Output VARIABLE. Used with '-A view'.

-A              List actions.
"

if (( EUID == 0 )); then
    PREFIX=${PREFIX:-/usr/local}
else
    PREFIX=${PREFIX:-$HOME}
fi

interactive ${INTERACTIVE:-0}
verbose     ${VERBOSE:-0}

EDITOR=$(first "$VISUAL" "$EDITOR" "vi")

# COMMAND-LINE OPTIONS {{{1

unset OPTIND
while getopts ":hifvqC:N:P:A:V:" options; do
    case $options in
        N) PROFILE_NAME=$OPTARG ;;
        P) PROFILE=$OPTARG ;;
        V) VARIABLE=$OPTARG ;;

        A) profile_actions; exit 0 ;;

        C) CONFIG_DIR=$OPTARG ;;

        i) interactive 1 ;;
        f) interactive 0 ;;

        v) verbose 1 ;;
        q) verbose 0 ;;

        h) usage_exit 0 ;;
        *) usage_exit 1 ;;
    esac
done && shift $(($OPTIND - 1))

ACTION=${1:-load}

#}}}

if [[ ! $PROFILE_NAME ]]; then
    error "PROFILE_NAME is not set. Either export it or use -N."
    exit 1
fi

# Depending on whether or not we have root privileges,
# the config directory will be in $HOME or /usr/local/etc
if [[ ! $CONFIG_DIR ]]; then
    if [[ ${PREFIX%%/} == $HOME ]]; then
        CONFIG_DIR=$PREFIX/.${PROFILE_NAME%.*}
    else
        CONFIG_DIR=$PREFIX/etc/${PROFILE_NAME%.*}
    fi
fi

PROFILE_DIR=$CONFIG_DIR/profiles

# Verify that ACTION is valid
if ! profile_actions | grep -q "^$ACTION$"; then
    error_exit "Invalid profile action '$ACTION'."
fi

profile_$ACTION || error_exit "Could not $ACTION profile(s)."
