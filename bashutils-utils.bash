#!/bin/bash

# Filename:      bashutils-utils.bash
# Description:   Miscellaneous utility functions for use in other scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Sat 2009-11-21 22:13:40 (-0500)

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

extname() #{{{1
{
    # Get the extension of the given filename.
    #
    # Usage examples:
    #     extname     foo.tar.gz  #==> gz
    #     extname -n2 foo.tar.gz  #==> tar.gz

    local levels=1

    unset OPTIND
    while getopts ":n:" options; do
        case $options in
            n) levels=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    local filename=${1##*/}
    local fn=$filename
    local exts ext

    for i in $(seq 1 $levels); do
        ext=.${fn##*.}
        exts=$ext$exts
        fn=${fn%$ext}
        [[ $exts == .$filename ]] && return 1
    done

    echo "${exts##.}"
}

filename() #{{{1
{
    # Gets the filename of the given path.
    #
    # Usage examples:
    #     filename /path/to/file.txt  #==> file

    local ext=$(extname "$1")

    if [[ $ext ]]; then
        basename "$1" .$ext
    else
        basename "$1"
    fi
}

first() #{{{1
{
    # Get the first value that is non-empty.
    #
    # Usage example:
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
    sed "s:${char//:/\:}+:${char//:/\:}:g" | trim "$char"
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
    sed "s:^${char//:/\\:}*::;s:${char//:/\\:}*$::"
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
    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}

commonpath() #{{{1
{
    # Gets the common paths of the passed arguments.
    #
    # Usage examples:
    #     commonpath /home/user /home/user/bin  #==> /home/user

    [[ $1 == /* ]] || return 1
    [[ $2 == /* ]] || return 1

    local OIFS=$IFS; local IFS=/
    local dst=($(squeeze "/" <<<"$1"))
    local src=($(squeeze "/" <<<"$2"))
    IFS=$OIFS

    local tokens=()

    local idx
    for idx in "${!dst[@]}"; do
        [[ ${dst[$idx]} != ${src[$idx]} ]] && break
        tokens=("${tokens[@]}" "${dst[$idx]}")
    done

    OIFS=$IFS; IFS=/
    echo "/${tokens[*]}"
    IFS=$OIFS
}

relpath() #{{{1
{
    # Gets the relative path from src to dst.
    # It should give the same output as the python function os.path.relpath().
    # All arguments should be given as absolute paths.
    # All arguments default to the current directory.
    #
    # Usage examples:
    #     relpath /home/user     /home/user/bin  #==> bin
    #     relpath /home/user/bin /home/user      #==> ..
    #     relpath /foo/bar/baz   /               #==> ../../..
    #     relpath /foo/bar       /baz            #==> ../../baz
    #     relpath /home/user     /home/user      #==> .

    # Make sure that any duplicate slashes are removed.
    local dst=/$(squeeze "/" <<<"${1:-$PWD}")
    local src=/$(squeeze "/" <<<"${2:-$PWD}")

    local common=$(commonpath "$dst" "$src")

    dst=${dst#$common}; dst=${dst#/}
    src=${src#$common}; src=${src#/}

    local OIFS=$IFS; local IFS=/
    src=($src)
    IFS=$OIFS

    local rel=
    for i in "${!src[@]}"; do
        rel+=../
    done

    rel=${rel}${dst}

    # Handle some corner cases.
    # Arguments were the same path.
    [[ $rel ]] || rel=.
    # Make sure there are no trailing slashes.
    # ...except for root.
    [[ $rel == / ]] || rel=${rel%%/}

    echo "$rel"
}

increment_file() #{{{1
{
    # Get the next filename in line for the given file.
    #
    # Usage examples:
    #     increment_file does_not_exist  #==> does_not_exist
    #     increment_file does_exist      #==> does_exist (1)

    local file=$1
    local count=1

    while [[ -e $file ]]; do
        file="$1 ($((count++)))"
    done

    echo "$file"
}

listdir() #{{{1
{
    # Get the files in the given directory (1 level deep).
    local dir=$1; shift
    find "$dir" -maxdepth 1 -mindepth 1 "$@"
}

mounted() #{{{1
{
    # Check to see if a given device is mounted.
    mount | awk '{print $3}' | grep -q "^${1:-/}$"
}

mimetype() #{{{1
{
    file -ibL "$1" | awk -F";" '{print $1}'
}

execute_in() #{{{1
{
    local OPWD=$PWD; cd "$1"; shift
    "$@"; error=$?
    cd "$OPWD"
    return $error
}

#}}}1

BASHUTILS_UTILS_LOADED=1
