#!/bin/bash

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_UTILS_LOADED ]] && return

lower() #{{{1
{
    tr '[:upper:]' '[:lower:]'
}

upper() #{{{1
{
    tr '[:lower:]' '[:upper:]'
}

title() #{{{1
{
    sed 's/\<./\u&/g'
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
    # Get the value of the variable named by the given value.
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

truth_value() #{{{1
{
    # Gets a value that represents the "truthiness" of the given value.
    truth $1 && echo 1 || echo 0
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
    #     echo "  foo  bar baz " | trim
    #
    # This command will produce the string:
    #     "foo  bar baz"

    local char=${1:-[[:space:]]}
    sed "s:^${char//:/\\:}*::;s:${char//:/\\:}*$::"
}

trim_lines() #{{{1
{
    # Removes all leading/trailing blank lines.
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

    if (( $# > 0 )); then
        variables <<<"$@"
    else
        sed 's/[[:space:];]/\n/g' |
        egrep '^[a-zA-Z0-9_]+=' |
        awk -F= '{print $1}'
    fi
}

editor() #{{{1
{
    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}

commonpath() #{{{1
{
    [[ $1 == /* ]] || return 1
    [[ $2 == /* ]] || return 1

    OIFS=$IFS; IFS=/
    local dst=($(squeeze "/" <<<"$1"))
    local src=($(squeeze "/" <<<"$2"))
    IFS=$OIFS

    local tokens=()

    for i in "${!dst[@]}"; do
        [[ ${dst[$i]} != ${src[$i]} ]] && break
        tokens=("${tokens[@]}" "${dst[$i]}")
    done

    OIFS=$IFS; IFS=/
    echo "/${tokens[*]}"
    IFS=$OIFS
}

relpath() #{{{1
{
    dst=/$(squeeze "/" <<<"${1:-$PWD}")
    src=/$(squeeze "/" <<<"${2:-$PWD}")

    common=$(commonpath "$dst" "$src")

    dst=${dst#$common}; dst=${dst#/}
    src=${src#$common}; src=${src#/}

    OIFS=$IFS; IFS=/
    src=($src)
    IFS=$OIFS

    rel=
    for i in "${!src[@]}"; do
        rel+=../
    done

    rel=${rel}${dst}

    [[ $rel ]] || rel=.
    [[ $rel == / ]] || rel=${rel%/}

    echo "$rel"
}

#}}}1

BASHUTILS_UTILS_LOADED=1
