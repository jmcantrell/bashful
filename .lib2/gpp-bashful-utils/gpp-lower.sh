#include "1459670344-tmp/gpp-upper.sh"
#ifndeff LOWER
#define LOWER
lower() #{{{1
{
    # <doc:lower> {{{
    #
    # Convert stdin to lowercase.
    #
    # </doc:lower> }}}

    tr '[:upper:]' '[:lower:]'
}
#endif
