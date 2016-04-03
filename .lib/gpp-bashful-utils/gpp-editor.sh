#include "1459669815-tmp/gpp-first.sh"
#ifndeff EDITOR
#define EDITOR
editor() #{{{1
{
    # <doc:editor> {{{
    #
    # Execute the preferred editor.
    #
    # </doc:editor> }}}

    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}
#endif
#ifndeff EDITOR
#define EDITOR
editor() #{{{1
{
    # <doc:editor> {{{
    #
    # Execute the preferred editor.
    #
    # </doc:editor> }}}

    $(first "$VISUAL" "$EDITOR" "vi") "$@"
}
#endif
