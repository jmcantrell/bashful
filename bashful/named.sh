#ifndef NAMED
#define NAMED
named() #{{{1
{
    # <doc:named> {{{
    #
    # Get the value of the variable named the passed argument.
    #
    # The only reason why this function exists is because I can't do:
    #
    #     echo ${!"some_var"}
    #
    # Instead, I have to do:
    #
    #     some_var="The value I really want"
    #     name="some_var"
    #     echo ${!name}  #==> The value I really want
    #
    # With named(), I can now do:
    #
    #     some_var="The value I really want"
    #     named "some_var"  #==> The value I really want
    #
    # Which eliminates the need for an intermediate variable.
    #
    # </doc:named> }}}

    echo "${!1}"
}
#endif
