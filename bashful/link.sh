#include "verbose_echo.sh"
#include "verbose.sh"
#include "interactive_option.sh"
#include "interactive.sh"
#ifndef LINK
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
