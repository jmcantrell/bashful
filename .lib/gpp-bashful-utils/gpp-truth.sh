#include "1459669815-tmp/gpp-lower.sh"
#ifndeff TRUTH
#define TRUTH
truth() #{{{1
{
    # <doc:truth> {{{
    #
    # Determine the "truthiness" of the given value.
    #
    # Usage examples:
    #     truth True   #==> true
    #     truth        #==> false
    #     truth 1      #==> true
    #     truth false  #==> false
    #     truth on     #==> true
    #     truth spam   #==> false
    #
    # </doc:truth> }}}

    case $(lower <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}
#endif
#ifndeff TRUTH
#define TRUTH
truth() #{{{1
{
    # <doc:truth> {{{
    #
    # Determine the "truthiness" of the given value.
    #
    # Usage examples:
    #     truth True   #==> true
    #     truth        #==> false
    #     truth 1      #==> true
    #     truth false  #==> false
    #     truth on     #==> true
    #     truth spam   #==> false
    #
    # </doc:truth> }}}

    case $(lower <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}
#endif
