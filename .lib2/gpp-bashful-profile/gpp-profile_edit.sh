#include "1459670344-tmp/gpp-profile_verify.sh"
#include "1459670344-tmp/gpp-profile_hook.sh"
#include "1459670344-tmp/gpp-editor.sh"
#ifndeff PROFILE_EDIT
#define PROFILE_EDIT
profile_edit() #{{{1
{
    # <doc:profile_edit> {{{
    #
    # Edits an existing profile.
    #
    # </doc:profile_edit> }}}

    profile_verify || return 1
    profile_hook edit pre
    editor "$PROFILE_FILE"
    profile_hook edit post
}
#endif
