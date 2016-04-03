#include "gpp-squeeze_lines.sh"
#ifndeff EMBEDDED_RANGE
#define EMBEDDED_RANGE
embedded_range() #{{{1
{
    # <doc:embedded_range> {{{
    #
    # Get embedded text between a given range.
    #
    # Usage: embedded_range START END [FILE...]
    #
    # </doc:embedded_range> }}}

    local s=${1//\//\\/}; shift
    local e=${1//\//\\/}; shift
    local c="^[[:space:]]*#[[:space:]]*"

    sed -n "/$c$s/,/$c$e/p" "$@" | sed '1d;$d' | sed "s/$c//" | squeeze_lines
}
#endif
