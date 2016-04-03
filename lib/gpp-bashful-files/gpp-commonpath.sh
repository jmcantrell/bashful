#ifndef COMMONPATH
#define COMMONPATH
commonpath() #{{{1
{
    # <doc:commonpath> {{{
    #
    # Gets the common path of the paths passed on stdin.
    # Alternatively, paths can be passed as arguments.
    #
    # Usage: commonpath [PATH...]
    #
    # </doc:commonpath> }}}

    local path

    # Make sure command line args go to stdin
    if (( $# > 0 )); then
        for path in "$@"; do
            echo "$path"
        done | commonpath
        return
    fi

    local prefix=$(
        while read -r; do
            echo "$(abspath "$REPLY")/"
        done | commonprefix
    )

    # We only want to break at path separators
    if [[ $prefix != */ ]]; then
        prefix=${prefix%/*}/
    fi

    # Only strip the trailing slash if it's not root (/)
    if [[ $prefix != / ]]; then
        prefix=${prefix%/}
    fi

    echo "$prefix"
}
#endif
