#!/bin/bash

# Filename:      bashutils-utils.bash
# Description:   Miscellaneous utility functions for use in other scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Wed 2010-01-27 13:12:26 (-0500)

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_UTILS_LOADED ]] && return

lower() #{{{1
{
    # Convert stdin to lowercase.

    tr '[:upper:]' '[:lower:]'
}

upper() #{{{1
{
    # Convert stdin to uppercase.

    tr '[:lower:]' '[:upper:]'
}

title() #{{{1
{
    # Convert stdin to titlecase.
    # Example: "foo bar baz" => "Foo Bar Baz"

    lower | sed 's/\<./\u&/g'
}

first() #{{{1
{
    # Get the first value that is non-empty.
    #
    # Usage examples:
    #     EDITOR=$(first "$VISUAL" "$EDITOR" vi)

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
    # Get the value of the variable named the passed argument.

    echo "${!1}"
}

truth() #{{{1
{
    # Determine the "truthiness" of the given value.
    #
    # Usage examples:
    #     truth True   #==> true
    #     truth        #==> false
    #     truth 1      #==> true
    #     truth false  #==> false
    #     truth on     #==> true
    #     truth spam   #==> false

    case $(tr A-Z a-z <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}

truth_echo() #{{{1
{
    # Depending on the "truthiness" of the given value, echo the first (true)
    # or second (false) value.

    if truth "$1"; then
        echo "$2"
    else
        echo "$3"
    fi
}

truth_value() #{{{1
{
    # Gets a value that represents the "truthiness" of the given value.

    truth_echo "$1" 1 0
}

squeeze() #{{{1
{
    # Removes leading/trailing whitespace and condenses all other consecutive
    # whitespace into a single space.
    #
    # Usage examples:
    #     echo    "  foo  bar   baz  " | squeeze
    #
    # This command will produce the string:
    #     "foo bar baz"

    local char=${1:-[[:space:]]}
    sed "s%\(${char//%/\\%}\)\+%\1%g" | trim "$char"
}

squeeze_lines() #{{{1
{
    # Removes all leading/trailing blank lines and condenses all other
    # consecutive blank lines into a single blank line.

    sed '/^[[:space:]]+$/s/.*//g' | cat -s | trim_lines
}

trim() #{{{1
{
    # Removes all leading/trailing whitespace
    #
    # Usage examples:
    #     echo "  foo  bar baz " | trim  #==> "foo  bar baz"

    local char=${1:-[[:space:]]}
    sed "s%^${char//%/\\%}*%%;s%${char//%/\\%}*$%%"
}

trim_lines() #{{{1
{
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

    sed ':a;$!{N;ba;};s/^[[:space:]]*\n//;s/\n[[:space:]]*$//'
}

sleep_until() #{{{1
{
    # Causes the running process to wait until the given date.
    # If the date is in the past, it immediately returns.

    local secs=$(($(date -d "$1" +%s) - $(date +%s)))
    (( secs > 0 )) && sleep $secs
}

variables() #{{{1
{
    # Pulls all variable names from the input.

    sed 's/[[:space:];]/\n/g' |
    egrep '^[a-zA-Z0-9_]+=' |
    awk -F= '{print $1}'
}

editor() #{{{1
{
    # Execute the preferred editor.

    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}

repeat() #{{{1
{
    # Repeat a command a given number of times.

    local count=$1; shift
    local i
    for i in $(seq 1 $count); do
        "$@"
    done
}

lines() #{{{1
{
    # Get all lines except for comments and blank lines.

    egrep -v '^[[:space:]]*#|^[[:space:]]*$' "$@"
}

commonprefix() #{{{1
{
    # Gets the common prefix of the strings passed on stdin.

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
    # Sorts a list.
    #
    # Usage examples:
    #     echo "c b a"   | sort_list       #==> a b c
    #     echo "c, b, a" | sort_list ", "  #==> a, b, c

    local delim=${1:- }
    local item list

    OIFS=$IFS; IFS=$'\n'
    for item in $(sed "s%${delim//%/\%}%\n%g" | sort); do
        IFS=$OIFS
        list+="$(trim <<<"$item")$delim"
    done

    echo "${list%%$delim}"
}

execute_in() #{{{1
{
    # Execute a command in a given directory.

    local OPWD=$PWD; cd "$1"; shift
    "$@"; error=$?
    cd "$OPWD"
    return $error
}

#}}}1

BASHUTILS_UTILS_LOADED=1
