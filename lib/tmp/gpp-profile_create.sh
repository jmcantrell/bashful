#include "lib/tmp/gpp-warn.sh"
#include "lib/tmp/gpp-variables.sh"
#include "lib/tmp/gpp-squeeze_lines.sh"
#include "lib/tmp/gpp-profile_hook.sh"
#include "lib/tmp/gpp-profile_file.sh"
#include "lib/tmp/gpp-interactive.sh"
#include "lib/tmp/gpp-input.sh"
#include "lib/tmp/gpp-info.sh"
#include "lib/tmp/gpp-flatten.sh"
#include "lib/tmp/gpp-error.sh"
#include "lib/tmp/gpp-editor.sh"
#ifndeff PROFILE_CREATE
#define PROFILE_CREATE
profile_create() #{{{1
{
    # <doc:profile_create> {{{
    #
    # Creates a new profile.
    #
    # </doc:profile_create> }}}

    [[ $PROFILE ]] || PROFILE=$(input -c -p "Enter profile" -d "${PWD##*/}")

    profile_file || return 1

    mkdir -p "$PROFILE_DIR"

    if [[ -f $PROFILE_FILE ]]; then
        error "Profile '$PROFILE' already exists."
        return 1
    fi

    info -c "Creating new profile '$PROFILE'..."

    profile_hook create pre

    local default=$PROFILE_DEFAULT

    local variables=(
        'PROFILE'
        'PROFILE_NAME'
        "${PROFILE_DEFAULT_VARIABLES[@]}"
    )

    local default=$(flatten "$PROFILE_DEFAULT" "${variables[@]}")

    squeeze_lines <<<"$default" >$PROFILE_FILE

    if interactive; then
        editor "$PROFILE_FILE"
    else
        warn -c "Profile '$PROFILE_FILE' may need to be modified."
    fi

    profile_hook create post
}
#endif
