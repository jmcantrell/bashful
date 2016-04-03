#include "1459670344-tmp/gpp-verbose_echo.sh"
#include "1459670344-tmp/gpp-verbose.sh"
#include "1459670344-tmp/gpp-interactive_option.sh"
#include "1459670344-tmp/gpp-interactive.sh"
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
