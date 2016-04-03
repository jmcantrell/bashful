#include "1459670344-tmp/gpp-lower.sh"
#ifndeff UPPER
#define UPPER
upper() #{{{1
{
    # <doc:upper> {{{
    #
    # Convert stdin to uppercase.
    #
    # </doc:upper> }}}

    tr '[:lower:]' '[:upper:]'
}
#endif
