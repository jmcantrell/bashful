#include "lib/tmp/gpp-truth.sh"
#include "lib/tmp/gpp-interactive.sh"
#ifndeff INPUT
#define INPUT
input() #{{{1
{
    # <doc:input> {{{
    #
    # Prompts the user to input text.
    #
    # Usage: input [-cs] [-p PROMPT] [-d DEFAULT]
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
    # </doc:input> }}}

    local p="Enter value"
    local d c s reply

    unset OPTIND
    while getopts ":p:d:cs" option; do
        case $option in
            p) p=$OPTARG ;;
            d) d=$OPTARG ;;
            c) c=1 ;;
            s) s=-s ;;
        esac
    done && shift $(($OPTIND - 1))

    [[ $s ]] && unset d

    if truth $c && ! interactive; then
        echo "$d"
        return
    fi

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    [[ $s ]] || p="${p}${d:+ [$d]}"
    read $s -ep "$p: " reply || return 1
    [[ $s ]] && echo >&2

    echo "${reply:-$d}"
}
#endif
