#include "gpp-verbose.sh"
#include "gpp-truth.sh"
#ifndeff WARN
#define WARN
warn() #{{{1
{
    # <doc:warn> {{{
    #
    # Displays a colorized (if available) warning message.
    #
    # Usage: warn [-c] [MESSAGE]
    #
    # </doc:warn> }}}

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

    local msg=${1:-A warning has occurred.}

    # Shorten home paths, if they exist.
    msg=${msg//$HOME/\~}

    echo -e "${term_bold}${term_fg_yellow}WARNING: ${term_fg_white}${msg}${term_reset}" >&2
}
#endif
