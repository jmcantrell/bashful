#include "lower.sh"
#ifndef UPPER
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
