#include "1459670344-tmp/gpp-question.sh"
#include "1459670344-tmp/gpp-profile_verify.sh"
#include "1459670344-tmp/gpp-profile_hook.sh"
#include "1459670344-tmp/gpp-info.sh"
#ifndeff PROFILE_DELETE
#define PROFILE_DELETE
profile_delete() #{{{1
{
    # <doc:profile_delete> {{{
    #
    # Deletes an existing profile.
    #
    # </doc:profile_delete> }}}

    profile_verify || return 1
    question -c -p "Are you sure you want to delete '$PROFILE'?" || return 1
    info -c "Deleting profile '$PROFILE'..."
    profile_hook delete pre
    rm -f "$PROFILE_FILE"
    profile_hook delete post
}
#endif
