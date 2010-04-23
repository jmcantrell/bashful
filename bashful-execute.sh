#!/bin/bash

# Filename:      bashful-execute.sh
# Description:   Functions for building commands.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Fri 2010-04-23 12:54:19 (-0400)

# doc bashful-execute {{{
#
# The execute library provides functions for building and executing commands.
#
# doc-end bashful-execute }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_EXECUTE_LOADED ]] && return

execute() #{{{1
{
    # doc execute {{{
    #
    # Execute a given command or stored command.
    #
    # There are a couple of variables that affect the behavior.
    #
    #     EXECUTE_CMD
    #
    # If set, this will be executed and then unset.
    #
    #     EXECUTE_CMD_PREV
    #
    # This will be the same as EXECUTE_CMD after execution. If EXECUTE_CMD is
    # not set, this variable will be used for execution. The intention is that
    # you can run execute multiple times and it will use the same command, but
    # as soon as you start adding more arguments with execute_push(), it get's
    # reset.
    #
    # Usage: execute [ARGUMENT...]
    #
    # doc-end execute }}}

    if (( ${#EXECUTE_CMD[@]} > 0 )); then
        "${EXECUTE_CMD[@]}" "$@"
    elif (( ${#EXECUTE_CMD_PREV[@]} > 0 )); then
        "${EXECUTE_CMD_PREV[@]}" "$@"
    else
        "$@"
    fi

    EXECUTE_CMD_PREV=("${EXECUTE_CMD[@]}")
    unset EXECUTE_CMD
}

execute_in() #{{{1
{
    # doc execute_in {{{
    #
    # Execute a command in a given directory.
    #
    # Usage: execute_in DIRECTORY [COMMAND...]
    #
    # doc-end execute_in }}}

    local OPWD=$PWD; cd "$1"; shift
    execute "$@"; error=$?
    cd "$OPWD"
    return $error
}

execute_push() #{{{1
{
    # doc execute_push {{{
    #
    # Add an argument to the stored command.
    #
    # Usage: execute_push [ARGUMENT...]
    #
    # doc-end execute_push }}}

    EXECUTE_CMD=("${EXECUTE_CMD[@]}" "$@")
}

execute_pop() #{{{1
{
    # doc execute_pop {{{
    #
    # Remove the last (or given number) argument for the stored command.
    #
    # Usage: execute_pop [NUM_OF_ARGS]
    #
    # doc-end execute_pop }}}

    local i
    for (( i=0; i<${1:-1}; i++ )); do
        unset EXECUTE_CMD[${#EXECUTE_CMD[@]}-1]
    done
}

execute_clear() #{{{1
{
    # doc execute_clear {{{
    #
    # Clear stored commands.
    #
    # Usage: execute_clear
    #
    # doc-end execute_clear }}}

    unset EXECUTE_CMD
    unset EXECUTE_CMD_PREV
}

#}}}1

BASHFUL_EXECUTE_LOADED=1
