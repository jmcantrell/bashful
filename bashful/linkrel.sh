#include "relpath.sh"
#include "link.sh"
#ifndef LINKREL
#define LINKREL
linkrel() #{{{1
{
    # <doc:linkrel> {{{
    #
    # Like link, but uses relpath to make the paths relative.
    #
    # Usage: linkrel SOURCE [DESTINATION]
    #
    # </doc:link> }}}

    local dir=$(relpath "${@%/*}")/
    dir=${dir##./}
    link "${dir}${1##*/}" "$2"
}
#endif
