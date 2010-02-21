#!/bin/bash

# Filename:    bashful-doc.sh
# Description: Functions for extracting embedded documentation.
# Maintainer:  Jeremy Cantrell <jmcantrell@gmail.com>

# doc bashful-doc {{{
#
# The doc library provides a way to extract documentation from scripts.
#
# Normally, I would prefer to use getopts to setup a -h/--help option, but in
# some cases it isn't practical or it can conflict with other functions. This
# provides a nice alternative with no side-effects.
#
# Within the script, a section of documentation is denoted like this:
#
#     # doc NAME
#     #
#     # DOCUMENTATION TEXT GOES HERE
#     #
#     # doc-end NAME
#
# doc-end bashful-doc }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_DOC_LOADED ]] && return

source bashful-utils

doc() #{{{1
{
    # doc doc {{{
    #
    # Usage: doc NAME [FILE...]
    # Retrieve embedded documentation from scripts.
    #
    # doc-end doc }}}

    local name=$1; shift
    sed -n "/# doc $name\>/,/# doc-end $name\>/p" "$@" |
    sed '1d;$d' | sed 's/^[[:space:]]*# \?//' | squeeze_lines
}

doc_help() #{{{1
{
    # doc doc_help {{{
    #
    # Usage: doc_help SCRIPT [COMMAND]
    # Display full documentation for a given script/command.
    #
    # doc-end doc_help }}}

    local src=$(type -p "$1")
    local cmd=$2
    local cmds

    if [[ $cmd ]]; then
        doc "$cmd" "$src"
    else
        doc "$(basename "$src" .sh)" "$src"
        cmds=$(doc_commands "$src")
        if [[ $cmds ]]; then
            echo -e "\nAvailable commands:\n"
            echo "$cmds" | sed 's/^/    /'
        fi
    fi
}

doc_execute() #{{{1
{
    # doc doc_execute {{{
    #
    # Usage:
    #     doc_execute SCRIPT
    #     doc_execute SCRIPT help [COMMAND]
    #     doc_execute SCRIPT [COMMAND] [OPTIONS] [ARGUMENTS]
    #
    # Display the documentation for a given script if there are no arguments
    # or the only argument is "help".
    #
    # Display the documentation for a given
    # command if the first two arguments are "help" and the command.
    #
    # If not using one of the help methods, the given command will be executed
    # as if it were run directly.
    #
    # doc-end doc_execute }}}

    local src=$(type -p "$1"); shift

    if [[ ! $1 || $1 == help ]]; then
        shift
        doc_help "$src" "$1"
    else
        source "$src"; "$@"
    fi
}

doc_commands() #{{{1
{
    # doc doc_commands {{{
    #
    # Usage: doc_commands [FILE...]
    # Show all doc tags in given files.
    #
    # doc-end doc_commands }}}

    local f cmd

    local libs=$(
        for f in "$@"; do
            basename "$f" .sh
        done
        )

    local t="doc"
    sed -n "/^\s*#\s\+$t\s/p" "$@" |
    sed "s/^.*\s$t\s\+\([^[:space:]]\+\).*$/\1/" | sort -u |
    grep -v "$libs"
}

#}}}1

BASHFUL_DOC_LOADED=1
