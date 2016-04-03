#ifndef FIRST
#define FIRST
first() #{{{1
{
    # <doc:first> {{{
    #
    # Get the first value that is non-empty.
    #
    # Usage examples:
    #     EDITOR=$(first "$VISUAL" "$EDITOR" vi)
    #
    # </doc:first> }}}

    local value
    for value in "$@"; do
        if [[ $value ]]; then
            echo "$value"
            return 0
        fi
    done
    return 1
}
#endif
