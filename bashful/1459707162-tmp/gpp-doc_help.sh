#include "gpp-pager.sh"
#include "gpp-doc_topics.sh"
#include "gpp-doc.sh"
#ifndef DOC_HELP
#define DOC_HELP
doc_help() #{{{1
{
    # <doc:doc_help> {{{
    #
    # Display full documentation for a given script/topic.
    #
    # Usage: doc_help SCRIPT [TOPIC]
    #
    # </doc:doc_help> }}}

    local src=$(type -p "$1")
    local cmd=$2
    local cmds

    {
        if [[ $cmd ]]; then
            doc "$cmd" "$src"
        else
            doc "$(basename "$src" .sh)" "$src"
            cmds=$(doc_topics "$src")
            if [[ $cmds ]]; then
                echo -e "\nAvailable topics:\n"
                echo "$cmds" | sed 's/^/    /'
            fi
        fi
    } | pager
}
#endif
