#include "1459669815-tmp/gpp-verbose_echo.sh"
#include "1459669815-tmp/gpp-verbose.sh"
#include "1459669815-tmp/gpp-interactive_option.sh"
#include "1459669815-tmp/gpp-interactive.sh"
#ifndeff REMOVE
#define REMOVE
remove() #{{{1
{
    # <doc:remove> {{{
    #
    # Version of rm that respects the interactive/verbose settings.
    # Accepts the same options/arguments as rm.
    #
    # </doc:remove> }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    $SUDO rm -r $(interactive_option) $(verbose_echo -v) "$@"
}
#endif
#ifndeff REMOVE
#define REMOVE
remove() #{{{1
{
    # <doc:remove> {{{
    #
    # Version of rm that respects the interactive/verbose settings.
    # Accepts the same options/arguments as rm.
    #
    # </doc:remove> }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    $SUDO rm -r $(interactive_option) $(verbose_echo -v) "$@"
}
#endif
