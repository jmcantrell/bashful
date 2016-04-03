#include "gpp-variables.sh"
#ifndeff FLATTEN
#define FLATTEN
flatten() #{{{1
{
    # <doc:flatten> {{{
    #
    # Substitute variable names with variables.
    #
    # The default is to try to substitute all environment variables, but if
    # any names are given, it will be limited to just those.
    #
    # The placeholder syntax can be changed by setting the following variables:
    #
    #     FLATTEN_L  # Default: {{
    #     FLATTEN_R  # Default: }}
    #
    # Usage: flatten TEXT [VAR...]
    #
    # </doc:flatten> }}}

    local t=$1; shift
    local n

    local fl=${FLATTEN_L:-\{\{}
    local fr=${FLATTEN_R:-\}\}}

    if (( $# == 0 )); then
        IFS=$'\n' set -- $(set | variables)
    fi

    for n in "$@"; do
        t=${t//${fl}${n}${fr}/${!n}}
    done

    echo "$t"
}
#endif
