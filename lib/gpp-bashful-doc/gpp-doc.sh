#include "./lib/gpp-bashful-doc/gpp-embedded_tag.sh"
#ifndeff DOC
#define DOC
doc() #{{{1
{
    # <doc:doc> {{{
    #
    # Retrieve embedded documentation from scripts.
    #
    # Usage: doc NAME [FILE...]
    #
    # </doc:doc> }}}

    local name=$1; shift
    embedded_tag "doc:$name" "$@"
}
#endif
