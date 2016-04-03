#ifndeff ACTIONS
#define ACTIONS
actions() #{{{1
{
    # <doc:actions> {{{
    #
    # Show all functions that are prefixed with SCRIPT_NAME (stripped off).
    #
    # Usage: actions [NAME]
    #
    # </doc:actions> }}}

    local name=${1:-$SCRIPT_NAME}
    declare -F |
    awk '{print $NF}' |
    grep "^${name}_" |
    sed "s/^${name}_//" |
    sort -u
}
#endif
