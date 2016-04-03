#ifndeff TIMESTAMP
#define TIMESTAMP
timestamp() #{{{1
{
    # <doc:timestamp> {{{
    #
    # Nothing special, really. Just a frequently used date format.
    #
    # </doc:timestamp> }}}

    date +%Y%m%d%H%M%S
}
#endif
