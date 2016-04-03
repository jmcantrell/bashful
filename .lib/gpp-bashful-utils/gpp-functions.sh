#ifndeff FUNCTIONS
#define FUNCTIONS
functions() #{{{1
{
    # <doc:functions> {{{
    #
    # Pulls all function names from stdin.
    #
    # </doc:functions> }}}

    sed 's/[[:space:];]/\n/g' "$@" |
    grep -E '^[a-zA-Z0-9_-]+\(\)' |
    sed 's/().*$//' | sort -u
}
#endif
#ifndeff FUNCTIONS
#define FUNCTIONS
functions() #{{{1
{
    # <doc:functions> {{{
    #
    # Pulls all function names from stdin.
    #
    # </doc:functions> }}}

    sed 's/[[:space:];]/\n/g' "$@" |
    grep -E '^[a-zA-Z0-9_-]+\(\)' |
    sed 's/().*$//' | sort -u
}
#endif
