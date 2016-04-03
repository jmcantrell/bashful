#ifndeff LISTDIR
#define LISTDIR
listdir() #{{{1
{
    # <doc:listdir> {{{
    #
    # List the files in the given directory (1 level deep).
    # Accepts the same options as the find command.
    #
    # Usage: listdir DIR [OPTIONS]
    #
    # </doc:listdir> }}}

    local dir=$1; shift
    find "$dir" -maxdepth 1 -mindepth 1 "$@"
}
#endif
#ifndeff LISTDIR
#define LISTDIR
listdir() #{{{1
{
    # <doc:listdir> {{{
    #
    # List the files in the given directory (1 level deep).
    # Accepts the same options as the find command.
    #
    # Usage: listdir DIR [OPTIONS]
    #
    # </doc:listdir> }}}

    local dir=$1; shift
    find "$dir" -maxdepth 1 -mindepth 1 "$@"
}
#endif
