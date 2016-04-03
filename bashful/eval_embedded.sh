#include "embedded_tag.sh"
#ifndef EVAL_EMBEDDED
#define EVAL_EMBEDDED
eval_embedded() #{{{1
{
    # <doc:eval_embedded> {{{
    #
    # Eval embedded code contained in a given tag.
    #
    # Usage: eval_embedded NAME [FILE...]
    #
    # </doc:eval_embedded> }}}

    local name=$1; shift
    eval "$(embedded_tag "eval:$name" "$@")"
}
#endif
