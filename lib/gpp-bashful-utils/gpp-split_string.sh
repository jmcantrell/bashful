#include "./lib/gpp-bashful-utils/gpp-trim.sh"
#ifndeff SPLIT_STRING
#define SPLIT_STRING
split_string() #{{{1
{
    # <doc:split_string> {{{
    #
    # Split text from stdin into a list.
    #
    # DELIMITER defaults to ",".
    #
    # Usage: split_string [DELIMITER]
    #
    # Usage examples:
    #     echo "foo, bar, baz" | split_string      #==> foo\nbar\nbaz
    #     echo "foo|bar|baz"   | split_string "|"  #==> foo\nbar\nbaz
    #
    # </doc:split_string> }}}

    local delim=${1:-,}
    local line str

    while read -r; do
        OIFS=$IFS; IFS=$delim
        for str in $REPLY; do
            IFS=$OIFS
            trim <<<"$str"
        done
    done
}
#endif
