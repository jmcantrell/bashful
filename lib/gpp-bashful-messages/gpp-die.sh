#include "./lib/gpp-bashful-messages/gpp-error.sh"
#ifndeff DIE
#define DIE
die() #{{{1
{
    # <doc:die> {{{
    #
    # Displays an error message and exits with the given error code.
    #
    # Usage: die [MESSAGE] [ERROR]
    #
    # </doc:die> }}}

    error "$1"; exit ${2:-1}
}
#endif
