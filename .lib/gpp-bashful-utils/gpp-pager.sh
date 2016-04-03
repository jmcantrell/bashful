#include "1459669815-tmp/gpp-first.sh"
#ifndeff PAGER
#define PAGER
pager() #{{{1
{
    # <doc:pager> {{{
    #
    # Execute the preferred pager.
    #
    # </doc:pager> }}}

    $(first "$PAGER" "less")
}
#endif
#ifndeff PAGER
#define PAGER
pager() #{{{1
{
    # <doc:pager> {{{
    #
    # Execute the preferred pager.
    #
    # </doc:pager> }}}

    $(first "$PAGER" "less")
}
#endif
