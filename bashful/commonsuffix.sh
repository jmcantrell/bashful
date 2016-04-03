#include "commonprefix.sh"
#ifndef COMMONSUFFIX
#define COMMONSUFFIX
commonsuffix() #{{{1
{
    # <doc:commonsuffix> {{{
    #
    # Gets the common suffix of the strings passed on stdin.
    #
    # Usage examples:
    #     echo -e "foobar\nbabar" | commonsuffix  #==> bar
    #     echo -e "broom\ngroom"  | commonsuffix  #==> room
    #
    # </doc:commonsuffix> }}}

    if (( $# > 0 )); then
        local str
        for str in "$@"; do
            echo "$str"
        done | commonsuffix
        return
    fi

    rev | commonprefix | rev
}
#endif
