#ifndeff CAMEL
#define CAMEL
camel() #{{{1
{
    # <doc:camel> {{{
    #
    # Make text from stdin camel case.
    #
    # </doc:camel> }}}

    sed 's/_/ /g' |
    sed 's/\<\(.\)/\U\1/g' |
    sed 's/ //g'
}
#endif
