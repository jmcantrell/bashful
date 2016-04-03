#include "gpp-trim.sh"
#ifndeff SORT_LIST
#define SORT_LIST
sort_list() #{{{1
{
    # <doc:sort_list> {{{
    #
    # Sorts a list from stdin.
    #
    # Usage: sort_list [-ur] [DELIMITER]
    #
    # Usage examples:
    #     echo "c b a"     | sort_list       #==> a b c
    #     echo "c, b, a"   | sort_list ", "  #==> a, b, c
    #     echo "c b b b a" | sort_list -u    #==> a b c
    #     echo "c b a"     | sort_list -r    #==> c b a
    #
    # </doc:sort_list> }}}

    local r u

    unset OPTIND
    while getopts ":ur" option; do
        case $option in
            u) u=-u ;;
            r) r=-r ;;
        esac
    done && shift $(($OPTIND - 1))

    local delim=${1:- }
    local item list

    OIFS=$IFS; IFS=$'\n'
    for item in $(sed "s%${delim//%/\%}%\n%g" | sort $r $u); do
        IFS=$OIFS
        list+="$(trim <<<"$item")$delim"
    done

    echo "${list%%$delim}"
}
#endif
