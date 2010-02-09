#!/bin/bash

# Filename:      bashutils-utils.sh
# Description:   Miscellaneous utility functions for use in other scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Tue 2010-02-09 00:42:21 (-0500)

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_UTILS_LOADED ]] && return

lower() #{{{1
{
    # autodoc-begin lower {{{
    #
    # Convert stdin to lowercase.
    #
    # autodoc-end lower }}}

    tr '[:upper:]' '[:lower:]'
}

upper() #{{{1
{
    # autodoc-begin upper {{{
    #
    # Convert stdin to uppercase.
    #
    # autodoc-end upper }}}

    tr '[:lower:]' '[:upper:]'
}

title() #{{{1
{
    # autodoc-begin title {{{
    #
    # Convert stdin to titlecase.
    #
    # autodoc-end title }}}

    lower | sed 's/\<./\u&/g'
}

first() #{{{1
{
    # autodoc-begin first {{{
    #
    # Get the first value that is non-empty.
    #
    # Usage examples:
    #     EDITOR=$(first "$VISUAL" "$EDITOR" vi)
    #
    # autodoc-end first }}}

    local value
    for value in "$@"; do
        if [[ $value ]]; then
            echo "$value"
            return
        fi
    done
}

named() #{{{1
{
    # autodoc-begin named {{{
    #
    # Get the value of the variable named the passed argument.
    #
    # autodoc-end named }}}

    echo "${!1}"
}

truth() #{{{1
{
    # autodoc-begin truth {{{
    #
    # Determine the "truthiness" of the given value.
    #
    # Usage examples:
    #     truth True   #==> true
    #     truth        #==> false
    #     truth 1      #==> true
    #     truth false  #==> false
    #     truth on     #==> true
    #     truth spam   #==> false
    #
    # autodoc-end truth }}}

    case $(tr A-Z a-z <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}

truth_echo() #{{{1
{
    # autodoc-begin truth_echo {{{
    #
    # Depending on the "truthiness" of the given value, echo the first (true)
    # or second (false) value.
    #
    # autodoc-end truth_echo }}}

    if truth "$1"; then
        echo "$2"
    else
        echo "$3"
    fi
}

truth_value() #{{{1
{
    # autodoc-begin truth_value {{{
    #
    # Gets a value that represents the "truthiness" of the given value.
    #
    # autodoc-end truth_value }}}

    truth_echo "$1" 1 0
}

squeeze() #{{{1
{
    # autodoc-begin squeeze {{{
    #
    # Removes leading/trailing whitespace and condenses all other consecutive
    # whitespace into a single space.
    #
    # Usage examples:
    #     echo "  foo  bar   baz  " | squeeze  #==> "foo bar baz"
    #
    # autodoc-end squeeze }}}

    local char=${1:-[[:space:]]}
    sed "s%\(${char//%/\\%}\)\+%\1%g" | trim "$char"
}

squeeze_lines() #{{{1
{
    # autodoc-begin squeeze_lines {{{
    #
    # Removes all leading/trailing blank lines and condenses all other
    # consecutive blank lines into a single blank line.
    #
    # autodoc-end squeeze_lines }}}

    sed '/^[[:space:]]+$/s/.*//g' | cat -s | trim_lines
}

trim() #{{{1
{
    # autodoc-begin trim {{{
    #
    # Removes all leading/trailing whitespace
    #
    # Usage examples:
    #     echo "  foo  bar baz " | trim  #==> "foo  bar baz"
    #
    # autodoc-end trim }}}

    local char=${1:-[[:space:]]}
    sed "s%^${char//%/\\%}*%%;s%${char//%/\\%}*$%%"
}

trim_lines() #{{{1
{
    # autodoc-begin trim_lines {{{
    #
    # Removes all leading/trailing blank lines.
    #
    # Explanation of sed command:
    #
    #     :a      # Set label a
    #     $!{     # For every line except the last...
    #         N   # Add to pattern space with a newline
    #         ba  # Go back to label a
    #     }
    #
    # The pattern space now consists of a single string containing newlines.
    #
    #     s/^[[:space:]]*\n//  # Remove all leading whitespace (blank lines).
    #     s/\n[[:space:]]*$//  # Remove all trailing whitespace (blank lines).
    #
    # autodoc-end trim_lines }}}

    sed ':a;$!{N;ba;};s/^[[:space:]]*\n//;s/\n[[:space:]]*$//'
}

sleep_until() #{{{1
{
    # autodoc-begin sleep_until {{{
    #
    # Causes the running process to wait until the given date.
    # If the date is in the past, it immediately returns.
    #
    # autodoc-end sleep_until }}}

    local secs=$(($(date -d "$1" +%s) - $(date +%s)))
    (( secs > 0 )) && sleep $secs
}

variables() #{{{1
{
    # autodoc-begin variables {{{
    #
    # Pulls all variable names from the input.
    #
    # autodoc-end variables }}}

    sed 's/[[:space:];]/\n/g' |
    egrep '^[a-zA-Z0-9_]+=' |
    sed 's/=.*$//' | sort -u
}

functions() #{{{1
{
    # autodoc-begin functions {{{
    #
    # Pulls all function names from the input.
    #
    # autodoc-end functions }}}

    sed 's/[[:space:];]/\n/g' |
    egrep '^[a-zA-Z0-9_-]+\(\)' |
    sed 's/().*$//' | sort -u
}

editor() #{{{1
{
    # autodoc-begin editor {{{
    #
    # Execute the preferred editor.
    #
    # autodoc-end editor }}}

    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}

repeat() #{{{1
{
    # autodoc-begin repeat {{{
    #
    # Repeat a command a given number of times.
    #
    # autodoc-end repeat }}}

    local count=$1; shift
    local i
    for i in $(seq 1 $count); do
        "$@"
    done
}

lines() #{{{1
{
    # autodoc-begin lines {{{
    #
    # Get all lines except for comments and blank lines.
    #
    # autodoc-end lines }}}

    egrep -v '^[[:space:]]*#|^[[:space:]]*$' "$@"
}

autodoc() #{{{1
{
    # autodoc-begin autodoc {{{
    #
    # Retrieve embedded documentation from scripts.
    #
    # Usage: autodoc NAME [FILE...]
    #
    # Within the script, a section of documentation is denoted like this:
    #
    #     # autodoc-begin NAME
    #     #
    #     # DOCUMENTATION TEXT GOES HERE
    #     #
    #     # autodoc-end NAME
    #
    # autodoc-end autodoc }}}

    local name=$1; shift
    sed -n "/# autodoc-begin $name\>/,/# autodoc-end $name\>/p" "$@" |
    sed '1d;$d' | sed 's/^[[:space:]]*# \?//' | squeeze_lines
}

autodoc_commands() #{{{1
{
    # autodoc-begin autodoc_commands {{{
    #
    # Show all autodoc tags in given files.
    #
    # Usage: autodoc_commands [FILE...]
    #
    # autodoc-end autodoc_commands }}}

    local t="autodoc-begin"
    sed -n "/^\s*#\s\+$t\s/p" "$@" |
    sed "s/^.*\s$t\s\+\([^[:space:]]\+\).*$/\1/" | sort -u
}

commonprefix() #{{{1
{
    # autodoc-begin commonprefix {{{
    #
    # Gets the common prefix of the strings passed on stdin.
    #
    # autodoc-end commonprefix }}}

    local i str compare prefix

    if (( $# > 0 )); then
        for str in "$@"; do
            echo "$str"
        done | commonprefix
        return
    fi

    while read str; do
        [[ $prefix ]] || prefix=$str
        i=0
        unset compare
        while true; do
            [[ ${str:$i:1} || ${prefix:$i:1} ]] || break
            [[ ${str:$i:1} != ${prefix:$i:1} ]] && break
            compare+=${str:$((i++)):1}
        done
        prefix=$compare
        echo "$prefix"
    done | tail -n1
}

sort_list() #{{{1
{
    # autodoc-begin sort_list {{{
    #
    # Sorts a list.
    #
    # Usage examples:
    #     echo "c b a"     | sort_list       #==> a b c
    #     echo "c, b, a"   | sort_list ", "  #==> a, b, c
    #     echo "c b b b a" | sort_list -u    #==> a b c
    #     echo "c b a"     | sort_list -r    #==> c b a
    #
    # autodoc-end sort_list }}}

    local reverse unique

    unset OPTIND
    while getopts ":ur" option; do
        case $option in
            u) unique=-u ;;
            r) reverse=-r ;;
        esac
    done && shift $(($OPTIND - 1))

    local delim=${1:- }
    local item list

    OIFS=$IFS; IFS=$'\n'
    for item in $(sed "s%${delim//%/\%}%\n%g" | sort $reverse $unique); do
        IFS=$OIFS
        list+="$(trim <<<"$item")$delim"
    done

    echo "${list%%$delim}"
}

split_string() #{{{1
{
    # autodoc-begin split_string {{{
    #
    # Split a given string into a list.
    #
    # Usage examples:
    #     echo "foo, bar, baz" | split_string         #==> foo\nbar\nbaz
    #     echo "foo|bar|baz"   | split_string -d "|"  #==> foo\nbar\nbaz
    #
    # autodoc-end split_string }}}

    local delim=","
    local line str

    unset OPTIND
    while getopts ":d:" option; do
        case $option in
            d) delim=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    while read line; do
        OIFS=$IFS; IFS=$delim
        for str in $line; do
            IFS=$OIFS
            trim <<<"$str"
        done
    done
}

join_lines() #{{{1
{
    # autodoc-begin join_lines {{{
    #
    # Joins a list into a string.
    #
    # Usage examples:
    #     echo -e "foo\nbar\nbaz" | join_lines         #==> foo, bar, baz
    #     echo -e "foo\nbar\nbaz" | join_lines -d "|"  #==> foo|bar|baz
    #
    # autodoc-end join_lines }}}

    local delim=", "
    local value

    unset OPTIND
    while getopts ":d:" option; do
        case $option in
            d) delim=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    while read value; do
        echo -ne "${value}${delim}"
    done | sed "s/$delim$//"
    echo
}

execute_in() #{{{1
{
    # autodoc-begin execute_in {{{
    #
    # Execute a command in a given directory.
    #
    # autodoc-end execute_in }}}

    local OPWD=$PWD; cd "$1"; shift
    "$@"; error=$?
    cd "$OPWD"
    return $error
}

#}}}1

BASHUTILS_UTILS_LOADED=1
