#include "1459669815-tmp/gpp-doc_help.sh"
#ifndeff DOC_EXECUTE
#define DOC_EXECUTE
doc_execute() #{{{1
{
    # <doc:doc_execute> {{{
    #
    # Display the documentation for a given script if there are no arguments
    # or the only argument is "help".
    #
    # Display the documentation for a given topic if the first two arguments
    # are "help" and the topic.
    #
    # If not using one of the help methods, the given command will be executed
    # as if it were run directly.
    #
    # Usage:
    #     doc_execute SCRIPT
    #     doc_execute SCRIPT help [TOPIC]
    #     doc_execute SCRIPT [TOPIC/COMMAND] [OPTIONS] [ARGUMENTS]
    #
    # </doc:doc_execute> }}}

    local src=$(type -p "$1"); shift

    if [[ ! $1 || $1 == help ]]; then
        shift
        doc_help "$src" "$1"
    else
        source "$src"; "$@"
    fi
}
#endif
#ifndeff DOC_EXECUTE
#define DOC_EXECUTE
doc_execute() #{{{1
{
    # <doc:doc_execute> {{{
    #
    # Display the documentation for a given script if there are no arguments
    # or the only argument is "help".
    #
    # Display the documentation for a given topic if the first two arguments
    # are "help" and the topic.
    #
    # If not using one of the help methods, the given command will be executed
    # as if it were run directly.
    #
    # Usage:
    #     doc_execute SCRIPT
    #     doc_execute SCRIPT help [TOPIC]
    #     doc_execute SCRIPT [TOPIC/COMMAND] [OPTIONS] [ARGUMENTS]
    #
    # </doc:doc_execute> }}}

    local src=$(type -p "$1"); shift

    if [[ ! $1 || $1 == help ]]; then
        shift
        doc_help "$src" "$1"
    else
        source "$src"; "$@"
    fi
}
#endif
