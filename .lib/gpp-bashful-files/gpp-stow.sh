#include "1459669815-tmp/gpp-linkrel.sh"
#include "1459669815-tmp/gpp-files.sh"
#ifndeff STOW
#define STOW
stow() #{{{1
{
    # <doc:stow> {{{
    #
    # Replicate a directory tree and link regular files.
    #
    # </doc:stow> }}}

    local src=$1
    local dst=${2:-$PWD}

    local OIFS=$IFS; IFS=$'\n'
    for f in $(files "$src"); do
        IFS=$OIFS
        local nf=$dst/${f#$src/}
        mkdir -p "$(dirname "$nf")"
        linkrel "$f" "$nf"
    done
}
#endif
#ifndeff STOW
#define STOW
stow() #{{{1
{
    # <doc:stow> {{{
    #
    # Replicate a directory tree and link regular files.
    #
    # </doc:stow> }}}

    local src=$1
    local dst=${2:-$PWD}

    local OIFS=$IFS; IFS=$'\n'
    for f in $(files "$src"); do
        IFS=$OIFS
        local nf=$dst/${f#$src/}
        mkdir -p "$(dirname "$nf")"
        linkrel "$f" "$nf"
    done
}
#endif
