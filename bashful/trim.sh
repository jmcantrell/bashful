#include "rtrim.sh"
#include "ltrim.sh"
#ifndef TRIM
#define TRIM
trim() #{{{1
{
    # <doc:trim> {{{
    #
    # Removes all leading/trailing whitespace
    #
    # Usage examples:
    #     echo "  foo  bar baz " | trim  #==> "foo  bar baz"
    #
    # </doc:trim> }}}

    ltrim "$1" | rtrim "$1"
}
#endif
