#ifndeff EXECUTE_POP
#define EXECUTE_POP
execute_pop() #{{{1
{
    # <doc:execute_pop> {{{
    #
    # Remove the last (or given number) argument for the stored command.
    #
    # Usage: execute_pop [NUM_OF_ARGS]
    #
    # </doc:execute_pop> }}}

    local i
    for (( i=0; i<${1:-1}; i++ )); do
        unset EXECUTE_CMD[${#EXECUTE_CMD[@]}-1]
    done
}
#endif
#ifndeff EXECUTE_POP
#define EXECUTE_POP
execute_pop() #{{{1
{
    # <doc:execute_pop> {{{
    #
    # Remove the last (or given number) argument for the stored command.
    #
    # Usage: execute_pop [NUM_OF_ARGS]
    #
    # </doc:execute_pop> }}}

    local i
    for (( i=0; i<${1:-1}; i++ )); do
        unset EXECUTE_CMD[${#EXECUTE_CMD[@]}-1]
    done
}
#endif
