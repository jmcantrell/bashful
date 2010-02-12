#!/bin/bash

# Filename:      bashful-autodoc.sh
# Description:   Functions for extracting embedded documentation.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Fri 2010-02-12 15:20:15 (-0500)

# autodoc-begin bashful-autodoc {{{
#
# The autodoc library provides a way to extract documentation from scripts.
#
# Normally, I would prefer to use getopts to setup a -h/--help option, but in
# some cases it isn't practical or it can conflict with other functions. This
# provides a nice alternative with no side-effects.
#
# Within the script, a section of documentation is denoted like this:
#
#     # autodoc-begin NAME
#     #
#     # DOCUMENTATION TEXT GOES HERE
#     #
#     # autodoc-end NAME
#
# autodoc-end bashful-autodoc }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-autodoc
    autodoc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_AUTODOC_LOADED ]] && return

source bashful-utils

autodoc() #{{{1
{
    # autodoc-begin autodoc {{{
    #
    # Usage: autodoc NAME [FILE...]
    # Retrieve embedded documentation from scripts.
    #
    # autodoc-end autodoc }}}

    local name=$1; shift
    sed -n "/# autodoc-begin $name\>/,/# autodoc-end $name\>/p" "$@" |
    sed '1d;$d' | sed 's/^[[:space:]]*# \?//' | squeeze_lines
}

autodoc_help() #{{{1
{
    # autodoc-begin autodoc_help {{{
    #
    # Usage: autodoc_help SCRIPT [COMMAND]
    # Display full documentation for a given script/command.
    #
    # autodoc-end autodoc_help }}}

    local src=$(type -p "$1")
    local cmd=$2
    local cmds

    if [[ $cmd ]]; then
        autodoc "$cmd" "$src" >&2
    else
        {
            autodoc "$(basename "$src" .sh)" "$src"
            cmds=$(autodoc_commands "$src")
            if [[ $cmds ]]; then
                echo -e "\nAvailable commands:\n"
                echo "$cmds" | sed 's/^/    /'
            fi
        } >&2
    fi
}

autodoc_execute() #{{{1
{
    # autodoc-begin autodoc_execute {{{
    #
    # Usage:
    #     autodoc_execute SCRIPT
    #     autodoc_execute SCRIPT help [COMMAND]
    #     autodoc_execute SCRIPT [COMMAND] [OPTIONS] [ARGUMENTS]
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
    # autodoc-end autodoc_execute }}}

    local src=$(type -p "$1"); shift

    if [[ ! $1 || $1 == help ]]; then
        shift
        autodoc_help "$src" "$1"
    else
        source "$src"; "$@"
    fi
}

autodoc_commands() #{{{1
{
    # autodoc-begin autodoc_commands {{{
    #
    # Usage: autodoc_commands [FILE...]
    # Show all autodoc tags in given files.
    #
    # autodoc-end autodoc_commands }}}

    local f cmd

    local libs=$(
        for f in "$@"; do
            basename "$f" .sh
        done
        )

    local t="autodoc-begin"
    sed -n "/^\s*#\s\+$t\s/p" "$@" |
    sed "s/^.*\s$t\s\+\([^[:space:]]\+\).*$/\1/" | sort -u |
    grep -v "$libs"
}

#}}}1

BASHFUL_AUTODOC_LOADED=1
