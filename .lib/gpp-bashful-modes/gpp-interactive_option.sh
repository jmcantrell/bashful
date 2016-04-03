#include "1459669815-tmp/gpp-interactive_echo.sh"
#ifndeff INTERACTIVE_OPTION
#define INTERACTIVE_OPTION
interactive_option() #{{{1
{
    # <doc:interactive_option> {{{
    #
    # Echo the appropriate flag depending on the state of interactive mode.
    #
    # </doc:interactive_option> }}}

    interactive_echo "-i" "-f"
}
#endif
#ifndeff INTERACTIVE_OPTION
#define INTERACTIVE_OPTION
interactive_option() #{{{1
{
    # <doc:interactive_option> {{{
    #
    # Echo the appropriate flag depending on the state of interactive mode.
    #
    # </doc:interactive_option> }}}

    interactive_echo "-i" "-f"
}
#endif
