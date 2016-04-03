#ifndeff PROFILE_HOOK
#define PROFILE_HOOK
profile_hook() #{{{1
{
    # <doc:profile_hook> {{{
    #
    # Execute a specified profile hook.
    #
    # Usage: profile_hook ACTION HOOK
    #
    # </doc:profile_hook> }}}

    local command=profile_${1}_${2}
    if type $command &>/dev/null; then
        $command
    fi
}
#endif
#ifndeff PROFILE_HOOK
#define PROFILE_HOOK
profile_hook() #{{{1
{
    # <doc:profile_hook> {{{
    #
    # Execute a specified profile hook.
    #
    # Usage: profile_hook ACTION HOOK
    #
    # </doc:profile_hook> }}}

    local command=profile_${1}_${2}
    if type $command &>/dev/null; then
        $command
    fi
}
#endif
