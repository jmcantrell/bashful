#ifndeff SQUEEZE_LINES
#define SQUEEZE_LINES
squeeze_lines() #{{{1
{
    # <doc:squeeze_lines> {{{
    #
    # Removes all leading/trailing blank lines and condenses all other
    # consecutive blank lines into a single blank line.
    #
    # </doc:squeeze_lines> }}}

    sed '/^[[:space:]]\+$/s/.*//g' | cat -s | trim_lines
}
#endif
