#!/bin/bash

# Filename:      bashful-input.sh
# Description:   A set of functions for interacting with the user.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Tue 2010-04-13 13:54:06 (-0400)

# doc bashful-input {{{
#
# The input library provides functions for taking user input.
#
# All functions are sensitive to the following variables:
#
#     GUI          # If set/true, try to use gui dialogs.
#     INTERACTIVE  # If unset/false, the user will not be prompted.
#
# The INTERACTIVE variable only matters if the function is used with the
# interactive mode check option (-c).
#
# doc-end bashful-input }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_INPUT_LOADED ]] && return

source bashful-messages
source bashful-modes
source bashful-utils

input() #{{{1
{
    # doc input {{{
    #
    # Usage: input [-cs] [-p PROMPT] [-d DEFAULT]
    # Prompts the user to input text.
    #
    # Usage examples:
    #
    # If user presses enter with no response, foo is taken as the input:
    #     input -p "Enter value" -d foo
    #
    # User will only be prompted if interactive mode is enabled:
    #     input -c -p "Enter value"
    #
    # Input will be hidden:
    #     input -s -p "Enter password"
    #
    # doc-end input }}}

    local p="Enter value"
    local d c s reply

    unset OPTIND
    while getopts ":p:d:cs" option; do
        case $option in
            p) p=$OPTARG ;;
            d) d=$OPTARG ;;
            c) c=1 ;;
            s) s=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $s; then
        if gui; then
            s="--hide-text"
        else
            s="-s"
        fi
    fi

    if truth $c && ! interactive; then
        echo "$d"
        return
    fi

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    if gui; then
        reply=$(z "$p" --entry $s --entry-text="$d") || return 1
    else
        [[ $s ]] || p="${p}${d:+ [$d]}"
        read $s -ep "$p: " reply || return 1
        [[ $s ]] && echo >&2
    fi

    echo "${reply:-$d}"
}

input_lines() #{{{1
{
    # doc input_lines {{{
    #
    # Usage: input_lines [-c] [-p PROMPT]
    # Prompts the user to input text lists.
    #
    # doc-end input_lines }}}

    local p="Enter values"
    local c reply

    unset OPTIND
    while getopts ":p:c" option; do
        case $option in
            p) p=$OPTARG ;;
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! interactive; then
        return
    fi

    p+=" (one per line)"

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    if gui; then
        z "$p" --text-info --editable
    else
        echo "$p:" >&2
        cat  # Accept input until EOF (ctrl-d)
    fi
}

question() #{{{1
{
    # doc question {{{
    #
    # Usage: question [-c] [-p PROMPT] [-d DEFAULT]
    # Prompts the user with a yes/no question.
    # The default value can be anything that evaluates to true/false.
    # See documentation for the "truth" command for more info.
    #
    # Usage examples:
    #
    # If user presses enter with no response, answer will be "yes":
    #     question -p "Continue?" -d1
    #
    # User will only be prompted if interactive mode is enabled:
    #     question -c -p "Continue?"
    #
    # doc-end question }}}

    local p="Are you sure you want to proceed?"
    local d c reply choice

    unset OPTIND
    while getopts ":p:d:c" option; do
        case $option in
            p) p=$OPTARG ;;
            d) d=$OPTARG ;;
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! interactive; then
        return 0
    fi

    truth "$d" && d=y || d=n

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    if gui; then
        z "$p" --question
    else
        truth $(input -d $d -p "$p")
    fi

    return $?
}

choice() #{{{1
{
    # doc choice {{{
    #
    # Usage: choice [-c] [-p PROMPT] [CHOICE...]
    # Prompts the user to choose from a set of choices.
    # If there is only one choice, it will be returned immediately.
    #
    # Usage examples:
    #     choice -p "Choose your favorite color" red green blue
    #
    # doc-end choice }}}

    local p="Select from these choices"
    local c

    unset OPTIND
    while getopts ":p:c" option; do
        case $option in
            p) p=$OPTARG ;;
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! interactive; then
        return
    fi

    if (( $# <= 1 )); then
        echo "$1"
        exit
    fi

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    if gui; then
        printf "%s\n" "$@" |
        z "$p" --list --column="Choices" || return 1
    else
        echo "$p:" >&2
        select choice in "$@"; do
            if [[ $choice ]]; then
                echo "$choice"
                break
            fi
        done
    fi
}

#}}}1

BASHFUL_INPUT_LOADED=1
