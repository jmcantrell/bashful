#include "1459669815-tmp/gpp-verbose.sh"
#include "1459669815-tmp/gpp-truth.sh"
#ifndeff ERROR
#define ERROR
error() #{{{1
{
    # <doc:error> {{{
    #
    # Displays a colorized (if available) error message.
    #
    # Usage: error [-c] [MESSAGE]
    #
    # </doc:error> }}}

    local c

    unset OPTIND
    while getopts ":c" option; do
        case $option in
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! verbose; then
        return
    fi

    local msg=${1:-An error has occurred.}

    # Shorten home paths, if they exist.
    msg=${msg//$HOME/\~}

    echo -e "${term_bold}${term_fg_red}ERROR: ${term_fg_white}${msg}${term_reset}" >&2
}
#endif
#ifndeff ERROR
#define ERROR
error() #{{{1
{
    # <doc:error> {{{
    #
    # Displays a colorized (if available) error message.
    #
    # Usage: error [-c] [MESSAGE]
    #
    # </doc:error> }}}

    local c

    unset OPTIND
    while getopts ":c" option; do
        case $option in
            c) c=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $c && ! verbose; then
        return
    fi

    local msg=${1:-An error has occurred.}

    # Shorten home paths, if they exist.
    msg=${msg//$HOME/\~}

    echo -e "${term_bold}${term_fg_red}ERROR: ${term_fg_white}${msg}${term_reset}" >&2
}
#endif
