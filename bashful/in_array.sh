#ifndef IN_ARRAY
#define IN_ARRAY
in_array() #{{{1
{
    # <doc:in_array> {{{
    #
    # Determine if a value is in an array.
    #
    # Usage: in_array [VALUE] [ARRAY]
    #
    # </doc:in_array> }}}

    local value=$1; shift
    for item in "$@"; do
        [[ $item == $value ]] && return 0
    done
    return 1
}
#endif
