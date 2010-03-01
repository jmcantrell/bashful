#!/bin/bash

# Filename:      bashful-modes.sh
# Description:   Set of functions to interact with different script modes.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-03-01 00:14:47 (-0500)

# doc bashful-modes {{{
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
# doc-end bashful-modes }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_MODES_LOADED ]] && return

source bashful-utils

gui() #{{{1
{
    # doc gui {{{
    #
    # Usage: gui [VALUE]
    # With no arguments, test if gui mode is enabled.
    # With one argument, set gui mode to given value.
    # Will only enable gui mode if X is running.
    #
    # doc-end gui }}}

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
    # doc interactive {{{
    #
    # Usage: interactive [VALUE]
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.
    #
    # doc-end interactive }}}

    if (( $# == 0 )); then
        truth $INTERACTIVE && return 0
        return 1
    fi

    export INTERACTIVE=$(truth_value $1)
}

interactive_echo() #{{{1
{
    # doc interactive_echo {{{
    #
    # Usage: interactive_echo [TRUE_VALUE] [FALSE_VALUE]
    # Will only echo the first argument if interactive mode is enabled.
    # Otherwise, echo the second argument.
    #
    # doc-end interactive_echo }}}

    truth_echo "$INTERACTIVE" "$1" "$2"
}

interactive_option() #{{{1
{
    # doc interactive_option {{{
    #
    # Echo the appropriate flag depending on the state of interactive mode.
    #
    # doc-end interactive_option }}}

    interactive_echo "-i" "-f"
}

verbose() #{{{1
{
    # doc verbose {{{
    #
    # Usage: verbose [VALUE]
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.
    #
    # doc-end verbose }}}

    if (( $# == 0 )); then
        truth $VERBOSE && return 0
        return 1
    fi

    export VERBOSE=$(truth_value $1)
}

verbose_echo() #{{{1
{
    # doc verbose_echo {{{
    #
    # Usage: verbose_echo [TRUE_VALUE] [FALSE_VALUE]
    # Will only echo the first argument if verbose mode is enabled.
    # Otherwise, echo the second argument.
    #
    # doc-end verbose_echo }}}

    truth_echo "$VERBOSE" "$1" "$2"
}

verbose_option() #{{{1
{
    # doc verbose_option {{{
    #
    # Echo the appropriate flag depending on the state of verbose mode.
    #
    # doc-end verbose_option }}}

    verbose_echo "-v" "-q"
}

verbose_execute() #{{{1
{
    # doc verbose_execute {{{
    #
    # Usage: verbose_execute [COMMAND]
    # Will execute the given command and only display the output if verbose
    # mode is enabled.
    #
    # doc-end verbose_execute }}}

    if verbose; then
        "$@"
    else
        "$@" &>/dev/null
    fi
}

#}}}1

BASHFUL_MODES_LOADED=1
