#!/bin/bash

# Filename:      bashutils-modes.sh
# Description:   Set of functions to interact with different script modes.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Tue 2010-02-09 23:13:06 (-0500)

# autodoc-begin bashutils-modes {{{
#
# The modes library provides functions for using getting/setting mode values.
#
# The modes are controlled by the following variables:
#
#     GUI          # If set/true, try to use gui dialogs.
#     INTERACTIVE  # If unset/false, the user will not be prompted.
#     VERBOSE      # If unset/false, the user will not see notifications.
#
# The following commands get/set these variables:
#
#     gui
#     interactive
#     verbose
#
# If called with no argument, it returns the state of the mode in question.
# If called with an argument, The mode is set to the value of the argument.
#
# The most common way that a mode would be set:
#
#     verbose ${VERBOSE:-1}
#
# This will set verbose mode to true if it is not already set.
#
# It can be used in the following way:
#
#     verbose && echo "Verbose mode is set!"
#
# autodoc-end bashutils-modes }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashutils-autodoc
    autodoc_execute "$0" "$@"
    exit
fi

[[ $BASHUTILS_MODES_LOADED ]] && return

source bashutils-utils

gui() #{{{1
{
    # autodoc-begin gui {{{
    #
    # Usage: gui [VALUE]
    # With no arguments, test if gui mode is enabled.
    # With one argument, set gui mode to given value.
    # Will only enable gui mode if X is running.
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
    # Usage: interactive [VALUE]
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.
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
    # Usage: interactive_echo [TRUE_VALUE] [FALSE_VALUE]
    # Will only echo the first argument if interactive mode is enabled.
    # Otherwise, echo the second argument.
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
    # Usage: verbose [VALUE]
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.
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
    # Usage: verbose_echo [TRUE_VALUE] [FALSE_VALUE]
    # Will only echo the first argument if verbose mode is enabled.
    # Otherwise, echo the second argument.
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
    # Usage: verbose_execute [COMMAND]
    # Will execute the given command and only display the output if verbose
    # mode is enabled.
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
