#ifndeff SLEEP_UNTIL
#define SLEEP_UNTIL
sleep_until() #{{{1
{
    # <doc:sleep_until> {{{
    #
    # Causes the running process to wait until the given date.
    # If the date is in the past, it immediately returns.
    #
    # </doc:sleep_until> }}}

    local secs=$(($(date -d "$1" +%s) - $(date +%s)))
    (( secs > 0 )) && sleep $secs
}
#endif
