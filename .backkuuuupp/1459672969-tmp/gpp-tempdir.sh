#include "gpp-tempfile.sh"
#ifndeff TEMPDIR
#define TEMPDIR
tempdir() #{{{1
{
    # <doc:tempdir> {{{
    #
    # Creates and keeps track of temp directories.
    #
    # Usage examples:
    #     tempdir    # $TEMPDIR is now a directory
    #
    # </doc:tempdir> }}}

    tempfile -d -t "$(basename "$0").XXXXXX"
    TEMPDIR=$TEMPFILE
}
#endif
