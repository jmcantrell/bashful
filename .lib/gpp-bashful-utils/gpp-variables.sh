#ifndeff VARIABLES
#define VARIABLES
variables() #{{{1
{
    # <doc:variables> {{{
    #
    # Pulls all variable names from stdin.
    #
    # </doc:variables> }}}

    sed 's/[[:space:];]/\n/g' "$@" |
    egrep '^[a-zA-Z0-9_]+=' |
    sed 's/=.*$//' | sort -u
}
#endif
#ifndeff VARIABLES
#define VARIABLES
variables() #{{{1
{
    # <doc:variables> {{{
    #
    # Pulls all variable names from stdin.
    #
    # </doc:variables> }}}

    sed 's/[[:space:];]/\n/g' "$@" |
    egrep '^[a-zA-Z0-9_]+=' |
    sed 's/=.*$//' | sort -u
}
#endif
