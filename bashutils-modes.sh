#!/bin/bash

# Filename:      bashutils-modes.sh
# Description:   Set of functions to interact with different script modes.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-02-08 23:49:32 (-0500)

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_MODES_LOADED ]] && return

source bashutils-utils

gui() #{{{1
{
    # autodoc-begin gui {{{
    #
    # With no arguments, test if gui mode is enabled.
    # With one argument, set gui mode to given value.
    # Will only enable gui mode if X is running.
    #
    # Usage: gui [VALUE]
    #
    # autodoc-end gui }}}

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
    # autodoc-begin interactive {{{
    #
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.
    #
    # Usage: interactive [VALUE]
    #
    # autodoc-end interactive }}}

    if (( $# == 0 )); then
        truth $INTERACTIVE && return 0
        return 1
    fi

    export INTERACTIVE=$(truth_value $1)
}

interactive_echo() #{{{1
{
    # autodoc-begin interactive_echo {{{
    #
    # Will only echo the first argument if interactive mode is enabled.
    # Otherwise, echo the second argument.
    #
    # Usage: interactive_echo [TRUE_VALUE] [FALSE_VALUE]
    #
    # autodoc-end interactive_echo }}}

    truth_echo "$INTERACTIVE" "$1" "$2"
}

interactive_option() #{{{1
{
    # autodoc-begin interactive_option {{{
    #
    # Echo the appropriate flag depending on the state of interactive mode.
    #
    # autodoc-end interactive_option }}}

    interactive_echo "-i" "-f"
}

verbose() #{{{1
{
    # autodoc-begin verbose {{{
    #
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.
    #
    # Usage: verbose [VALUE]
    #
    # autodoc-end verbose }}}

    if (( $# == 0 )); then
        truth $VERBOSE && return 0
        return 1
    fi

    export VERBOSE=$(truth_value $1)
}

verbose_echo() #{{{1
{
    # autodoc-begin verbose_echo {{{
    #
    # Will only echo the first argument if verbose mode is enabled.
    # Otherwise, echo the second argument.
    #
    # Usage: verbose_echo [TRUE_VALUE] [FALSE_VALUE]
    #
    # autodoc-end verbose_echo }}}

    truth_echo "$VERBOSE" "$1" "$2"
}

verbose_option() #{{{1
{
    # autodoc-begin verbose_option {{{
    #
    # Echo the appropriate flag depending on the state of verbose mode.
    #
    # autodoc-end verbose_option }}}

    verbose_echo "-v" "-q"
}

verbose_execute() #{{{1
{
    # autodoc-begin verbose_execute {{{
    #
    # Will execute the given command and only display the output if verbose
    # mode is enabled.
    #
    # Usage: verbose_execute [COMMAND]
    #
    # autodoc-end verbose_execute }}}

    if verbose; then
        "$@"
    else
        "$@" &>/dev/null
    fi
}

#}}}1

BASHUTILS_MODES_LOADED=1
