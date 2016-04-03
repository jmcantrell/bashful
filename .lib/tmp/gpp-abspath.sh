#include "lib/tmp/gpp-squeeze.sh"
#ifndeff ABSPATH
#define ABSPATH
abspath() #{{{1
{
    # <doc:abspath> {{{
    #
    # Gets the absolute path of the given path.
    # Will resolve paths that contain '.' and '..'.
    # Think readlink without the symlink resolution.
    #
    # Usage: abspath [PATH]
    #
    # </doc:abspath> }}}

    local path=${1:-$PWD}

    # Path looks like: ~user/...
    # Gods of bash, forgive me for using eval
    if [[ $path =~ ~[a-zA-Z] ]]; then
        if [[ ${path%%/*} =~ ^~[[:alpha:]_][[:alnum:]_]*$ ]]; then
            path=$(eval echo $path)
        fi
    fi

    # Path looks like: ~/...
    [[ $path == ~* ]] && path=${path/\~/$HOME}

    # Path is not absolute
    [[ $path != /* ]] && path=$PWD/$path

    path=$(squeeze "/" <<<"$path")

    local elms=()
    local elm
    local OIFS=$IFS; IFS="/"
    for elm in $path; do
        IFS=$OIFS
        [[ $elm == . ]] && continue
        if [[ $elm == .. ]]; then
            elms=("${elms[@]:0:$((${#elms[@]}-1))}")
        else
            elms=("${elms[@]}" "$elm")
        fi
    done
    IFS="/"
    echo "/${elms[*]}"
    IFS=$OIFS
}
#endif
