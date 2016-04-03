#include "lib/tmp/gpp-truth.sh"
#include "lib/tmp/gpp-interactive.sh"
#ifndeff PAUSE
#define PAUSE
pause() #{{{1
{
    # <doc:pause> {{{
    #
    # Pause and wait for user interaction.
    #
    # Usage: pause [OPTIONS]
    #
    # </doc:pause> }}}

    local p="Press any key to continue..."
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

    read -s -p "$p" -n1 && echo >&2
}
#endif
