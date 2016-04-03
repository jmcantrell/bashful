#include "./lib/gpp-bashful-files/gpp-commonsuffix.sh"
#include "./lib/gpp-bashful-files/gpp-abspath.sh"
#ifndeff COMMONTAIL
#define COMMONTAIL
commontail() #{{{1
{
    # <doc:commontail> {{{
    #
    # Gets the common tails of the paths passed on stdin.
    # Alternatively, paths can be passed as arguments.
    #
    # Usage: commontail [PATH...]
    #
    # Usage examples:
    #     commontail /foo/bar /boo/bar  #==> bar
    #     commontail /foo/bar /boo/far  #==>
    #
    # </doc:commontail> }}}

    local path

    # Make sure command line args go to stdin
    if (( $# > 0 )); then
        for path in "$@"; do
            echo "$path"
        done | commontail
        return
    fi

    local suffix=$(
        while read -r; do
            echo "$(abspath "$REPLY")"
        done | commonsuffix
    )

    echo "${suffix#*/}"
}
#endif
