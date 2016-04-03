#include "error.sh"
#include "cleanup.sh"
#ifndef TEMPFILE
#define TEMPFILE
tempfile() #{{{1
{
    # <doc:tempfile> {{{
    #
    # Creates and keeps track of temp files.
    #
    # Usage examples:
    #     tempfile    # $TEMPFILE is now a regular file
    #
    # </doc:tempfile> }}}

    TEMPFILE=$(mktemp "$@")
    if [[ ! $TEMPFILE ]]; then
        error "Could not create temporary file."
        return 1
    fi
    CLEANUP_FILES=("${CLEANUP_FILES[@]}" "$TEMPFILE")
    trap cleanup INT TERM EXIT
}
#endif
