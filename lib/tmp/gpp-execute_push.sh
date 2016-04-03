#ifndeff EXECUTE_PUSH
#define EXECUTE_PUSH
execute_push() #{{{1
{
    # <doc:execute_push> {{{
    #
    # Add an argument to the stored command.
    #
    # Usage: execute_push [ARGUMENT...]
    #
    # </doc:execute_push> }}}

    EXECUTE_CMD+=("$@")
}
#endif
