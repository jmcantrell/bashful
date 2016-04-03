#include "lib/tmp/gpp-truth.sh"
#include "lib/tmp/gpp-interactive.sh"
#include "lib/tmp/gpp-input.sh"
#ifndeff INPUT_LINES
#define INPUT_LINES
input_lines() #{{{1
{
    # <doc:input_lines> {{{
    #
    # Prompts the user to input text lists.
    #
    # Usage: input_lines [-c] [-p PROMPT]
    #
    # </doc:input_lines> }}}

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

    echo "$p:" >&2
    cat  # Accept input until EOF (ctrl-d)
}
#endif
