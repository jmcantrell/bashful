#ifndeff PROFILE_LIST
#define PROFILE_LIST
profile_list() #{{{1
{
    # <doc:profile_list> {{{
    #
    # List profiles.
    #
    # If called with no argument and PROFILE is not set, then all profiles
    # will be listed. If PROFILE is set, then it will be used as
    # a pattern to filter the list. If a pattern is passed, it will override
    # anything that PROFILE is set to.
    #
    # Usage: profile_list [PATTERN]
    #
    # Usage examples:
    #     profile_list bash-.*  # List all profiles starting with "bash-"
    #     profile_list .*       # Equivalent to: profile_list
    #
    # </doc:profile_list> }}}

    local profile=${1:-$PROFILE}

    listdir "$PROFILE_DIR" -type f |
    awk -F'/' '{print $NF}' |
    grep -v '^\.' |
    grep "${profile:+^$profile$}" |
    sort
}
#endif
