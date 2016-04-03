#include "1459669815-tmp/gpp-truth.sh"
#include "1459669815-tmp/gpp-interactive.sh"
#include "1459669815-tmp/gpp-input.sh"
#include "1459669815-tmp/gpp-choice.sh"
#ifndeff QUESTION
#define QUESTION
question() #{{{1
{
    # <doc:question> {{{
    #
    # Prompts the user with a yes/no question.
    # The default value can be anything that evaluates to true/false.
    # See documentation for the "truth" command for more info.
    #
    # Usage: question [-c] [-p PROMPT] [-d DEFAULT]
    #
    # Usage examples:
    #
    # If user presses enter with no response, answer will be "yes":
    #     question -p "Continue?" -d1
    #
    # User will only be prompted if interactive mode is enabled:
    #     question -c -p "Continue?"
    #
    # </doc:question> }}}

    local p="Are you sure you want to proceed?"
    local d c reply choice

    unset OPTIND
    while getopts ":p:d:c" option; do
        case $option in
            p) p=$OPTARG ;;
            d) d=$OPTARG ;;
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! interactive; then
        return 0
    fi

    truth "$d" && d=y || d=n

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    truth $(input -d $d -p "$p")
}
#endif
#ifndeff QUESTION
#define QUESTION
question() #{{{1
{
    # <doc:question> {{{
    #
    # Prompts the user with a yes/no question.
    # The default value can be anything that evaluates to true/false.
    # See documentation for the "truth" command for more info.
    #
    # Usage: question [-c] [-p PROMPT] [-d DEFAULT]
    #
    # Usage examples:
    #
    # If user presses enter with no response, answer will be "yes":
    #     question -p "Continue?" -d1
    #
    # User will only be prompted if interactive mode is enabled:
    #     question -c -p "Continue?"
    #
    # </doc:question> }}}

    local p="Are you sure you want to proceed?"
    local d c reply choice

    unset OPTIND
    while getopts ":p:d:c" option; do
        case $option in
            p) p=$OPTARG ;;
            d) d=$OPTARG ;;
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! interactive; then
        return 0
    fi

    truth "$d" && d=y || d=n

    # Shorten home paths, if they exist.
    p=${p//$HOME/~}

    truth $(input -d $d -p "$p")
}
#endif
