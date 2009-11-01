#!/bin/bash

source bashutils-modes
source bashutils-terminfo
source bashutils-utils

usage() #{{{1
{
    # Display usage information.
    # Will automatically populate certain sections if things like verbose or
    # interactive modes are set (either on or off).

    if [[ $SCRIPT_NAME ]]; then
        {
            echo "Usage: $SCRIPT_NAME [OPTIONS] $SCRIPT_ARGS"
            [[ $SCRIPT_USAGE ]] && echo "$SCRIPT_USAGE"

            echo
            echo "GENERAL OPTIONS"
            echo
            echo "    -h    Display this help message."

            if [[ $INTERACTIVE ]]; then
                echo
                echo "    -i    Interactive. Prompt for certain actions."
                echo "    -f    Don't prompt."
            fi

            if [[ $VERBOSE ]]; then
                echo
                echo "    -v    Be verbose."
                echo "    -q    Be quiet."
            fi

            if [[ $SCRIPT_OPTIONS ]]; then
                echo
                echo "APPLICATION OPTIONS"
                echo
                sed 's/^/    /' <<<"$SCRIPT_OPTIONS" | squeeze_lines
            fi
        } >&2
    fi
}
usage_exit() #{{{1
{
    # Display usage information and exit with the given error code.
    usage
    exit ${1:-0}
}

error() #{{{1
{
    # Displays a colorized (if available) error message.
    # If used with -c, message will only display if verbose mode is enabled.

    local check

    unset OPTIND
    while getopts ":c" options; do
        case $options in
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! verbose; then
        return
    fi

    local msg=${1:-An error has occurred.}

    if gui; then
        zenity --error --text="$msg"
    else
        info "${term_fg_red}${term_bold}ERROR: ${msg}${term_reset}"
    fi
}

error_exit() #{{{1
{
    # Displays an error message and exits with the given error code.
    error "$1"
    exit ${2:-1}
}

info() #{{{1
{
    # Displays a colorized (if available) informational message.
    # If used with -c, message will only display if verbose mode is enabled.

    local check

    unset OPTIND
    while getopts ":c" options; do
        case $options in
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! verbose; then
        return
    fi

    local msg=${1:-All updates are complete.}

    if gui; then
        zenity --info --text="$msg"
    else
        echo -e "${term_bold}${msg}${term_reset}" >&2
    fi
}

warn() #{{{1
{
    # Displays a colorized (if available) warning message.
    # If used with -c, message will only display if verbose mode is enabled.

    local check

    unset OPTIND
    while getopts ":c" options; do
        case $options in
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! verbose; then
        return
    fi

    local msg=${1:-Are you sure you want to proceed?}

    if gui; then
        zenity --warning --text="$msg"
    else
        info "${term_fg_yellow}${term_bold}WARNING: ${msg}${term_reset}"
    fi
}
