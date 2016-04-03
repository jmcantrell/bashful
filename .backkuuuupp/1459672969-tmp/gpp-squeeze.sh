#include "gpp-trim.sh"
#ifndeff SQUEEZE
#define SQUEEZE
squeeze() #{{{1
{
    # <doc:squeeze> {{{
    #
    # Removes leading/trailing whitespace and condenses all other consecutive
    # whitespace into a single space.
    #
    # Usage examples:
    #     echo "  foo  bar   baz  " | squeeze  #==> "foo bar baz"
    #
    # </doc:squeeze> }}}

    local char=${1:-[[:space:]]}
    sed "s%\(${char//%/\\%}\)\+%\1%g" | trim "$char"
}
#endif
