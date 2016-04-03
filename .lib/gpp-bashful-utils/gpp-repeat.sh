#ifndeff REPEAT
#define REPEAT
repeat() #{{{1
{
    # <doc:repeat> {{{
    #
    # Repeat a command a given number of times.
    #
    # </doc:repeat> }}}

    local count=$1; shift
    local i
    for i in $(seq 1 $count); do
        "$@"
    done
}
#endif
#ifndeff REPEAT
#define REPEAT
repeat() #{{{1
{
    # <doc:repeat> {{{
    #
    # Repeat a command a given number of times.
    #
    # </doc:repeat> }}}

    local count=$1; shift
    local i
    for i in $(seq 1 $count); do
        "$@"
    done
}
#endif
