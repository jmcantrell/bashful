#include "question.sh"
#include "profile_verify.sh"
#include "profile_hook.sh"
#include "info.sh"
#ifndef PROFILE_DELETE
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
