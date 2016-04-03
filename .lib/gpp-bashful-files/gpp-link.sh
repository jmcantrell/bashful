#include "1459669815-tmp/gpp-verbose_echo.sh"
#include "1459669815-tmp/gpp-verbose.sh"
#include "1459669815-tmp/gpp-interactive_option.sh"
#include "1459669815-tmp/gpp-interactive.sh"
#ifndeff LINK
#define LINK
link() #{{{1
{
    # <doc:link> {{{
    #
    # Version of ln that respects the interactive/verbose settings.
    #
    # Usage: link SOURCE [DESTINATION]
    #
    # </doc:link> }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    $SUDO ln -snT $(interactive_option) $(verbose_echo -v) "$@"
}
#endif
#ifndeff LINK
#define LINK
link() #{{{1
{
    # <doc:link> {{{
    #
    # Version of ln that respects the interactive/verbose settings.
    #
    # Usage: link SOURCE [DESTINATION]
    #
    # </doc:link> }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    $SUDO ln -snT $(interactive_option) $(verbose_echo -v) "$@"
}
#endif
