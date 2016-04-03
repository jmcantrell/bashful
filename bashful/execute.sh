#ifndef EXECUTE
#define EXECUTE
execute() #{{{1
{
    # <doc:execute> {{{
    #
    # Execute a given command or stored command.
    #
    # Usage: execute [ARGUMENT...]
    #
    # </doc:execute> }}}

    "${EXECUTE_CMD[@]}" "$@"
}
#endif
