#!/bin/bash

# Filename:    bashful-utils.sh
# Description: Miscellaneous utility functions for use in other scripts.
# Maintainer:  Jeremy Cantrell <jmcantrell@gmail.com>

# doc bashful-utils {{{
#
# The utils library provides miscellaneous functions.
#
# doc-end bashful-utils }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_UTILS_LOADED ]] && return

lower() #{{{1
{
    # doc lower {{{
    #
    # Convert stdin to lowercase.
    #
    # doc-end lower }}}

    tr '[:upper:]' '[:lower:]'
}

upper() #{{{1
{
    # doc upper {{{
    #
    # Convert stdin to uppercase.
    #
    # doc-end upper }}}

    tr '[:lower:]' '[:upper:]'
}

title() #{{{1
{
    # doc title {{{
    #
    # Convert stdin to titlecase.
    #
    # doc-end title }}}

    lower | sed 's/\<./\u&/g' |
    sed "s/'[[:upper:]]/\L&\l/g"
}

detox() #{{{1
{
    sed 's/[[:punct:]]/ /g' |
    sed 's/[^A-Za-z0-9 ]/ /g' |
    squeeze | sed 's/ /_/g' | lower
}

first() #{{{1
{
    # doc first {{{
    #
    # Get the first value that is non-empty.
    #
    # Usage examples:
    #     EDITOR=$(first "$VISUAL" "$EDITOR" vi)
    #
    # doc-end first }}}

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
    # doc named {{{
    #
    # Get the value of the variable named the passed argument.
    #
    # The only reason why this function exists is because I can't do:
    #
    #     echo ${!"some_var"}
    #
    # Instead, I have to do:
    #
    #     some_var="The value I really want"
    #     name="some_var"
    #     echo ${!name}  #==> The value I really want
    #
    # With named(), I can now do:
    #
    #     some_var="The value I really want"
    #     named "some_var"  #==> The value I really want
    #
    # Which eliminates the need for an intermediate variable.
    #
    # doc-end named }}}

    echo "${!1}"
}

truth() #{{{1
{
    # doc truth {{{
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
    # doc-end truth }}}

    case $(lower <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}

truth_echo() #{{{1
{
    # doc truth_echo {{{
    #
    # Depending on the "truthiness" of the given value, echo the first (true)
    # or second (false) value.
    #
    # doc-end truth_echo }}}

    if truth "$1"; then
        echo "$2"
    else
        echo "$3"
    fi
}

truth_value() #{{{1
{
    # doc truth_value {{{
    #
    # Gets a value that represents the "truthiness" of the given value.
    #
    # doc-end truth_value }}}

    truth_echo "$1" 1 0
}

squeeze() #{{{1
{
    # doc squeeze {{{
    #
    # Removes leading/trailing whitespace and condenses all other consecutive
    # whitespace into a single space.
    #
    # Usage examples:
    #     echo "  foo  bar   baz  " | squeeze  #==> "foo bar baz"
    #
    # doc-end squeeze }}}

    local char=${1:-[[:space:]]}
    sed "s%\(${char//%/\\%}\)\+%\1%g" | trim "$char"
}

squeeze_lines() #{{{1
{
    # doc squeeze_lines {{{
    #
    # Removes all leading/trailing blank lines and condenses all other
    # consecutive blank lines into a single blank line.
    #
    # doc-end squeeze_lines }}}

    sed '/^[[:space:]]+$/s/.*//g' | cat -s | trim_lines
}

trim() #{{{1
{
    # doc trim {{{
    #
    # Removes all leading/trailing whitespace
    #
    # Usage examples:
    #     echo "  foo  bar baz " | trim  #==> "foo  bar baz"
    #
    # doc-end trim }}}

    local char=${1:-[[:space:]]}
    sed "s%^${char//%/\\%}*%%;s%${char//%/\\%}*$%%"
}

trim_lines() #{{{1
{
    # doc trim_lines {{{
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
    # doc-end trim_lines }}}

    sed ':a;$!{N;ba;};s/^[[:space:]]*\n//;s/\n[[:space:]]*$//'
}

sleep_until() #{{{1
{
    # doc sleep_until {{{
    #
    # Causes the running process to wait until the given date.
    # If the date is in the past, it immediately returns.
    #
    # doc-end sleep_until }}}

    local secs=$(($(date -d "$1" +%s) - $(date +%s)))
    (( secs > 0 )) && sleep $secs
}

variables() #{{{1
{
    # doc variables {{{
    #
    # Pulls all variable names from the input.
    #
    # doc-end variables }}}

    sed 's/[[:space:];]/\n/g' |
    egrep '^[a-zA-Z0-9_]+=' |
    sed 's/=.*$//' | sort -u
}

functions() #{{{1
{
    # doc functions {{{
    #
    # Pulls all function names from the input.
    #
    # doc-end functions }}}

    sed 's/[[:space:];]/\n/g' |
    egrep '^[a-zA-Z0-9_-]+\(\)' |
    sed 's/().*$//' | sort -u
}

editor() #{{{1
{
    # doc editor {{{
    #
    # Execute the preferred editor.
    #
    # doc-end editor }}}

    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}

repeat() #{{{1
{
    # doc repeat {{{
    #
    # Repeat a command a given number of times.
    #
    # doc-end repeat }}}

    local count=$1; shift
    local i
    for i in $(seq 1 $count); do
        "$@"
    done
}

lines() #{{{1
{
    # doc lines {{{
    #
    # Get all lines except for comments and blank lines.
    #
    # doc-end lines }}}

    egrep -v '^[[:space:]]*#|^[[:space:]]*$' "$@"
}

commonprefix() #{{{1
{
    # doc commonprefix {{{
    #
    # Gets the common prefix of the strings passed on stdin.
    #
    # doc-end commonprefix }}}

    local i compare prefix

    if (( $# > 0 )); then
        local str
        for str in "$@"; do
            echo "$str"
        done | commonprefix
        return
    fi

    while read -r; do
        [[ $prefix ]] || prefix=$REPLY
        i=0
        unset compare
        while true; do
            [[ ${REPLY:$i:1} || ${prefix:$i:1} ]] || break
            [[ ${REPLY:$i:1} != ${prefix:$i:1} ]] && break
            compare+=${REPLY:$((i++)):1}
        done
        prefix=$compare
        echo "$prefix"
    done | tail -n1
}

sort_list() #{{{1
{
    # doc sort_list {{{
    #
    # Sorts a list.
    #
    # Usage examples:
    #     echo "c b a"     | sort_list       #==> a b c
    #     echo "c, b, a"   | sort_list ", "  #==> a, b, c
    #     echo "c b b b a" | sort_list -u    #==> a b c
    #     echo "c b a"     | sort_list -r    #==> c b a
    #
    # doc-end sort_list }}}

    local r u

    unset OPTIND
    while getopts ":ur" option; do
        case $option in
            u) u=-u ;;
            r) r=-r ;;
        esac
    done && shift $(($OPTIND - 1))

    local delim=${1:- }
    local item list

    OIFS=$IFS; IFS=$'\n'
    for item in $(sed "s%${delim//%/\%}%\n%g" | sort $r $u); do
        IFS=$OIFS
        list+="$(trim <<<"$item")$delim"
    done

    echo "${list%%$delim}"
}

split_string() #{{{1
{
    # doc split_string {{{
    #
    # Split a given string into a list.
    #
    # Usage examples:
    #     echo "foo, bar, baz" | split_string      #==> foo\nbar\nbaz
    #     echo "foo|bar|baz"   | split_string "|"  #==> foo\nbar\nbaz
    #
    # doc-end split_string }}}

    local delim=${1:-,}
    local line str

    while read -r; do
        OIFS=$IFS; IFS=$delim
        for str in $REPLY; do
            IFS=$OIFS
            trim <<<"$str"
        done
    done
}

join_lines() #{{{1
{
    # doc join_lines {{{
    #
    # Joins a list into a string.
    #
    # Usage examples:
    #     echo -e "foo\nbar\nbaz" | join_lines      #==> foo, bar, baz
    #     echo -e "foo\nbar\nbaz" | join_lines "|"  #==> foo|bar|baz
    #
    # doc-end join_lines }}}

    local delim=${1:-, }

    while read -r; do
        echo -ne "${REPLY}${delim}"
    done | sed "s/$delim$//"
    echo
}

execute_in() #{{{1
{
    # doc execute_in {{{
    #
    # Execute a command in a given directory.
    #
    # doc-end execute_in }}}

    local OPWD=$PWD; cd "$1"; shift
    "$@"; error=$?
    cd "$OPWD"
    return $error
}

#}}}1

BASHFUL_UTILS_LOADED=1
