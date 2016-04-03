#ifndef DOC_TOPICS
#define DOC_TOPICS
doc_topics() #{{{1
{
    # <doc:doc_topics> {{{
    #
    # Show all doc tags in given files.
    #
    # Usage: doc_topics [FILE...]
    #
    # </doc:doc_topics> }}}

    local src=$(type -p "$1")
    local t="doc"
    local c='^[[:space:]]*#[[:space:]]*'
    local n='<doc:\([^>]*\)>'

    sed -n "/$c$n/p" "$src" |
    sed "s/$c$n.*$/\1/" | sort -u |
    grep -v "^$(basename "$src")$"
}
#endif
