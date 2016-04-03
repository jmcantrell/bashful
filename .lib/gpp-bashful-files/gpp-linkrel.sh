#include "1459669815-tmp/gpp-relpath.sh"
#include "1459669815-tmp/gpp-link.sh"
#ifndeff LINKREL
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
#ifndeff LINKREL
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
