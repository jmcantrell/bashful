#ifndef RTRIM
#define RTRIM
rtrim() #{{{1
{
    # <doc:rtrim> {{{
    #
    # Removes all trailing whitespace (from the right).
    #
    # </doc:rtrim> }}}

    local char=${1:-[:space:]}
    sed "s%[${char//%/\\%}]*$%%"
}
#endif
