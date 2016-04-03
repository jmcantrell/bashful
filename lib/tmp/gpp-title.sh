#include "lib/tmp/gpp-upper.sh"
#include "lib/tmp/gpp-lower.sh"
#ifndeff TITLE
#define TITLE
title() #{{{1
{
    # <doc:title> {{{
    #
    # Convert stdin to titlecase.
    #
    # </doc:title> }}}

    lower | sed 's/\<./\u&/g' |
    sed "s/'[[:upper:]]/\L&\l/g"
}
#endif
