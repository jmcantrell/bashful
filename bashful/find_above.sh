#ifndef FIND_ABOVE
#define FIND_ABOVE
find_above() #{{{1
{
    # <doc:find_above> {{{
    #
    # Find the nearest file/directory above the current directory.
    # Takes the same options as find.
    #
    # Usage: find_above [OPTIONS]
    #
    # </doc:find_above> }}}

    local OPWD=$PWD
    local result
    while true; do
        find "$PWD" -maxdepth 1 -mindepth 1 "$@"
        [[ $PWD == / ]] && break
        cd ..
    done
    cd "$OPWD"
}
#endif
