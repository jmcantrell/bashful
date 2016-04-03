#include "1459669815-tmp/gpp-extname.sh"
#ifndeff FILENAME
#define FILENAME
filename() #{{{1
{
    # <doc:filename> {{{
    #
    # Gets the filename of the given path.
    #
    # Usage: filename [-n LEVELS] FILENAME
    #
    # Usage examples:
    #     filename     /path/to/file.txt     #==> file
    #     filename -n2 /path/to/file.tar.gz  #==> file
    #     filename     /path/to/file.tar.gz  #==> file
    #     filename -n1 /path/to/file.tar.gz  #==> file.tar
    #
    # </doc:filename> }}}

    basename "$1" $(extname "$@")
}
#endif
#ifndeff FILENAME
#define FILENAME
filename() #{{{1
{
    # <doc:filename> {{{
    #
    # Gets the filename of the given path.
    #
    # Usage: filename [-n LEVELS] FILENAME
    #
    # Usage examples:
    #     filename     /path/to/file.txt     #==> file
    #     filename -n2 /path/to/file.tar.gz  #==> file
    #     filename     /path/to/file.tar.gz  #==> file
    #     filename -n1 /path/to/file.tar.gz  #==> file.tar
    #
    # </doc:filename> }}}

    basename "$1" $(extname "$@")
}
#endif
