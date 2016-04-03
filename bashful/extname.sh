#include "lower.sh"
#include "filename.sh"
#ifndef EXTNAME
#define EXTNAME
extname() #{{{1
{
    # <doc:extname> {{{
    #
    # Get the extension of the given filename.
    #
    # Usage: extname [-n LEVELS] FILENAME
    #
    # Usage examples:
    #     extname     foo.txt     #==> .txt
    #     extname -n2 foo.tar.gz  #==> .tar.gz
    #     extname     foo.tar.gz  #==> .tar.gz
    #     extname -n1 foo.tar.gz  #==> .gz
    #
    # </doc:extname> }}}

    local levels

    unset OPTIND
    while getopts ":n:" option; do
        case $option in
            n) levels=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    local filename=${1##*/}

    [[ $filename == *.* ]] || return

    local fn=$filename
    local exts ext

    # Detect some common multi-extensions
    if [[ ! $levels ]]; then
        case $(lower <<<$filename) in
            *.tar.gz|*.tar.bz2) levels=2 ;;
        esac
    fi

    levels=${levels:-1}

    for (( i=0; i<$levels; i++ )); do
        ext=.${fn##*.}
        exts=$ext$exts
        fn=${fn%$ext}
        [[ $exts == $filename ]] && return
    done

    echo "$exts"
}
#endif
