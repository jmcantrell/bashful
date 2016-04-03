#include "gpp-verbose_echo.sh"
#include "gpp-verbose.sh"
#include "gpp-interactive_option.sh"
#include "gpp-interactive.sh"
#ifndeff MOVE
#define MOVE
move() #{{{1
{
    # <doc:move> {{{
    #
    # Version of mv that respects the interactive/verbose settings.
    # Accepts the same options/arguments as mv.
    #
    # </doc:name> }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    $SUDO mv -T $(interactive_option) $(verbose_echo -v) "$@"
}
#endif
