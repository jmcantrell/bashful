#ifndeff LTRIM
#define LTRIM
ltrim() #{{{1
{
    # <doc:ltrim> {{{
    #
    # Removes all leading whitespace (from the left).
    #
    # </doc:ltrim> }}}

    local char=${1:-[:space:]}
    sed "s%^[${char//%/\\%}]*%%"
}
#endif
#ifndeff LTRIM
#define LTRIM
ltrim() #{{{1
{
    # <doc:ltrim> {{{
    #
    # Removes all leading whitespace (from the left).
    #
    # </doc:ltrim> }}}

    local char=${1:-[:space:]}
    sed "s%^[${char//%/\\%}]*%%"
}
#endif
