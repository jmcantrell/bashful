#include "gpp-truth.sh"
#include "gpp-interactive.sh"
#ifndef CHOICE
#define CHOICE
choice() #{{{1
{
    # <doc:choice> {{{
    #
    # Prompts the user to choose from a set of choices.
    # If there is only one choice, it will be returned immediately.
    #
    # Usage: choice [-c] [-p PROMPT] [CHOICE...]
    #
    # Usage examples:
    #     choice -p "Choose your favorite color" red green blue
    #
    # </doc:choice> }}}

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

    echo "$p:" >&2
    select choice in "$@"; do
        if [[ $choice ]]; then
            echo "$choice"
            break
        fi
    done
}
#endif
