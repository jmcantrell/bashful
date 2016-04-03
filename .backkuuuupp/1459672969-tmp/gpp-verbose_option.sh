#include "gpp-verbose_echo.sh"
#ifndeff VERBOSE_OPTION
#define VERBOSE_OPTION
verbose_option() #{{{1
{
    # <doc:verbose_option> {{{
    #
    # Echo the appropriate flag depending on the state of verbose mode.
    #
    # </doc:verbose_option> }}}

    verbose_echo "-v" "-q"
}
#endif
