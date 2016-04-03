#include "lib/tmp/gpp-question.sh"
#include "lib/tmp/gpp-profile_verify.sh"
#include "lib/tmp/gpp-profile_hook.sh"
#include "lib/tmp/gpp-info.sh"
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
