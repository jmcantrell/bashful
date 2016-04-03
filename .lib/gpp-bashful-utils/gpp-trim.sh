#include "1459669815-tmp/gpp-rtrim.sh"
#include "1459669815-tmp/gpp-ltrim.sh"
#ifndeff TRIM
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
#ifndeff TRIM
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
