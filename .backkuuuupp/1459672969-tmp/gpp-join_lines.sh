#ifndeff JOIN_LINES
#define JOIN_LINES
join_lines() #{{{1
{
    # <doc:join_lines> {{{
    #
    # Joins lines from stdin into a string.
    #
    # DELIMITER defaults to ", ".
    #
    # Usage: join_lines [DELIMITER]
    #
    # Usage examples:
    #     echo -e "foo\nbar\nbaz" | join_lines      #==> foo, bar, baz
    #     echo -e "foo\nbar\nbaz" | join_lines "|"  #==> foo|bar|baz
    #
    # </doc:join_lines> }}}

    local delim=${1:-, }

    while read -r; do
        echo -ne "${REPLY}${delim}"
    done | sed "s/$delim$//"
    echo
}
#endif
