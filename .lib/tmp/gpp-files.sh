#ifndeff FILES
#define FILES
files() #{{{1
{
    # <doc:files> {{{
    #
    # List all the files in the given directory (recursively).
    # Will not display hidden files.
    # Accepts the same options as the find command.
    #
    # Usage: files DIR [OPTIONS]
    #
    # </doc:files> }}}

    local dir=$1; shift
    find "$dir" \( -type f -o -type l \) \! -wholename "*/.*" "$@"
}
#endif
