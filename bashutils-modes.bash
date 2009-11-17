#!/bin/bash

# Filename:      bashutils-modes.bash
# Description:   Utilities dealing with script modes.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2009-11-16 23:39:09 (-0500)

source bashutils-utils

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_MODES_LOADED ]] && return

gui() #{{{1
{
    # With no arguments, test if gui mode is enabled.
    # With one argument, set gui mode to given value.
    # Will only enable gui mode if X is running.
    if (( $# == 0 )); then
        if [[ $DISPLAY ]]; then
            truth $GUI && return 0
        fi
        return 1
    fi
    export GUI=$(truth_value $1)
}

interactive() #{{{1
{
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.
    if (( $# == 0 )); then
        truth $INTERACTIVE && return 0
        return 1
    fi
    export INTERACTIVE=$(truth_value $1)
}

interactive_echo() #{{{1
{
    # Will only echo the first argument if interactive mode is enabled.
    # Otherwise, echo the second argument.
    if interactive; then
        echo "$1"
    else
        echo "$2"
    fi
}

interactive_option() #{{{1
{
    # Echo the appropriate flag depending on the state of interactive mode.
    interactive_echo "-i" "-f"
}

verbose() #{{{1
{
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.
    if (( $# == 0 )); then
        truth $VERBOSE && return 0
        return 1
    fi
    export VERBOSE=$(truth_value $1)
}

verbose_echo() #{{{1
{
    # Will only echo the first argument if verbose mode is enabled.
    # Otherwise, echo the second argument.
    if verbose; then
        echo "$1"
    else
        echo "$2"
    fi
}

verbose_option() #{{{1
{
    # Echo the appropriate flag depending on the state of verbose mode.
    verbose_echo "-v" "-q"
}

verbose_execute() #{{{1
{
    # Will execute the given command and only display the output if verbose
    # mode is enabled.
    if verbose; then
        "$@"
    else
        "$@" &>/dev/null
    fi
}

#}}}1

BASHUTILS_MODES_LOADED=1
