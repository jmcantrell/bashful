#ifndef MOVE
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
