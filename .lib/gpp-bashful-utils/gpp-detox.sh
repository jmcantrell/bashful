#include "1459669815-tmp/gpp-squeeze.sh"
#include "1459669815-tmp/gpp-lower.sh"
#ifndeff DETOX
#define DETOX
detox() #{{{1
{
    # <doc:detox> {{{
    #
    # Make text from stdin slightly less insane.
    #
    # </doc:detox> }}}

    sed 's/[^A-Za-z0-9 ]/ /g' |
    squeeze | sed 's/ /_/g' | lower
}
#endif
#ifndeff DETOX
#define DETOX
detox() #{{{1
{
    # <doc:detox> {{{
    #
    # Make text from stdin slightly less insane.
    #
    # </doc:detox> }}}

    sed 's/[^A-Za-z0-9 ]/ /g' |
    squeeze | sed 's/ /_/g' | lower
}
#endif
