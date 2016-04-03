#ifndef COMMONPREFIX
#define COMMONPREFIX
commonprefix() #{{{1
{
    # <doc:commonprefix> {{{
    #
    # Gets the common prefix of the strings passed on stdin.
    #
    # Usage examples:
    #     echo -e "spam\nspace"   | commonprefix  #==> spa
    #     echo -e "foo\nbar\nbaz" | commonprefix  #==>
    #
    # </doc:commonprefix> }}}

    local i compare prefix

    if (( $# > 0 )); then
        local str
        for str in "$@"; do
            echo "$str"
        done | commonprefix
        return
    fi

    while read -r; do
        [[ $prefix ]] || prefix=$REPLY
        i=0
        unset compare
        while true; do
            [[ ${REPLY:$i:1} || ${prefix:$i:1} ]] || break
            [[ ${REPLY:$i:1} != ${prefix:$i:1} ]] && break
            compare+=${REPLY:$((i++)):1}
        done
        prefix=$compare
        echo "$prefix"
    done | tail -n1
}
#endif
