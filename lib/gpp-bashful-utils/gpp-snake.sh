#ifndeff SNAKE
#define SNAKE
snake() #{{{1
{
    # <doc:snake> {{{
    #
    # Make text from stdin snake case.
    #
    # </doc:snake> }}}

    sed 's/\([[:upper:]]\)/ \1/g' | detox
}
#endif
