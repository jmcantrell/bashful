#include "./lib/gpp-bashful-files/gpp-verbose_echo.sh"
#include "./lib/gpp-bashful-files/gpp-verbose.sh"
#include "./lib/gpp-bashful-files/gpp-interactive_option.sh"
#include "./lib/gpp-bashful-files/gpp-interactive.sh"
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
