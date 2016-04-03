#ifndef EMBEDDED_TAG
#define EMBEDDED_TAG
embedded_tag() #{{{1
{
    # <doc:embedded_tag> {{{
    #
    # Get the embedded text between a start and end XML-like tag.
    #
    # Usage: embedded_tag NAME
    #
    # </doc:embedded_tag> }}}

    local name=$1; shift
    embedded_range "<$name>" "</$name>" "$@"
}
#endif
