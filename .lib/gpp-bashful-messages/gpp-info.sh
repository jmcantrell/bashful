#include "1459669815-tmp/gpp-verbose.sh"
#include "1459669815-tmp/gpp-truth.sh"
#ifndeff INFO
#define INFO
info() #{{{1
{
    # <doc:info> {{{
    #
    # Displays a colorized (if available) informational message.
    #
    # Usage: info [-c] [MESSAGE]
    #
    # </doc:info> }}}

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

    local msg=${1:-All updates are complete.}

    # Shorten home paths, if they exist.
    msg=${msg//$HOME/\~}

    echo -e "${term_bold}${term_fg_blue}==> ${term_fg_white}${msg}${term_reset}" >&2
}
#endif
#ifndeff INFO
#define INFO
info() #{{{1
{
    # <doc:info> {{{
    #
    # Displays a colorized (if available) informational message.
    #
    # Usage: info [-c] [MESSAGE]
    #
    # </doc:info> }}}

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

    local msg=${1:-All updates are complete.}

    # Shorten home paths, if they exist.
    msg=${msg//$HOME/\~}

    echo -e "${term_bold}${term_fg_blue}==> ${term_fg_white}${msg}${term_reset}" >&2
}
#endif
