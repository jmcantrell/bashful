#include "gpp-verbose_echo.sh"
#include "gpp-verbose.sh"
#include "gpp-interactive_option.sh"
#include "gpp-interactive.sh"
#ifndeff COPY
#define COPY
copy() #{{{1
{
    # <doc:copy> {{{
    #
    # Version of cp that respects the interactive/verbose settings.
    # Accepts the same options/arguments as cp.
    #
    # </doc:copy> }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    $SUDO cp -Tr $(interactive_option) $(verbose_echo -v) "$@"
}
#endif
