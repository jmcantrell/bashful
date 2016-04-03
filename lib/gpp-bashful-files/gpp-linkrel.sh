#include "./lib/gpp-bashful-files/gpp-relpath.sh"
#include "./lib/gpp-bashful-files/gpp-link.sh"
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
