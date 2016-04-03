#ifndef FLATTEN_FILE
#define FLATTEN_FILE
flatten_file() #{{{1
{
    # <doc:flatten_file> {{{
    #
    # Substitute variable names with variables in a file.
    #
    # The default is to try to substitute all environment variables, but if
    # any names are given, it will be limited to just those.
    #
    # The placeholder syntax can be changed by setting the following variables:
    #
    #     FLATTEN_L  # Default: {{
    #     FLATTEN_R  # Default: }}
    #
    # Usage: flatten_file FILE [VAR...]
    #
    # </doc:flatten_file> }}}

    local fn=$1; shift

    [[ -f $fn ]] || return 1

    local n

    local fl=${FLATTEN_L:-\{\{}
    local fr=${FLATTEN_R:-\}\}}

    if (( $# == 0 )); then
        IFS=$'\n' set -- $(set | variables)
    fi

    for n in "$@"; do
        sed -i "s%${fl}${n//%/\%}${fr}%${!n}%g" "$fn"
    done
}
#endif
