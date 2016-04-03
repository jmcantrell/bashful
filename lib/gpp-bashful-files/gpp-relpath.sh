#include "./lib/gpp-bashful-files/gpp-commonpath.sh"
#include "./lib/gpp-bashful-files/gpp-abspath.sh"
#ifndeff RELPATH
#define RELPATH
relpath() #{{{1
{
    # <doc:relpath> {{{
    #
    # Gets the relative path from SOURCE to DESTINATION.
    # Output should mirror the python function os.path.relpath().
    # All arguments default to the current directory.
    #
    # Usage: relpath [DESTINATION] [SOURCE]
    #
    # Usage examples:
    #     relpath /home/user     /home/user/bin  #==> bin
    #     relpath /home/user/bin /home/user      #==> ..
    #     relpath /foo/bar/baz   /               #==> ../../..
    #     relpath /foo/bar       /baz            #==> ../../baz
    #     relpath /home/user     /home/user      #==> .
    #     relpath                                #==> .
    #
    # </doc:relpath> }}}

    local dst=$(abspath "$1")
    local src=$(abspath "$2")

    local common=$(commonpath "$dst" "$src")

    dst=${dst#$common}; dst=${dst#/}
    src=${src#$common}; src=${src#/}

    local OIFS=$IFS; local IFS=/
    src=($src)
    IFS=$OIFS

    local rel=
    for i in "${!src[@]}"; do
        rel+=../
    done

    rel=${rel}${dst}

    # Handle some corner cases.
    # Arguments were the same path.
    [[ $rel ]] || rel=.
    # Make sure there are no trailing slashes.
    # ...except for root.
    [[ $rel == / ]] || rel=${rel%%/}

    echo "$rel"
}
#endif
