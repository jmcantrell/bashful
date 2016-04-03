#ifndef CLEANUP
#define CLEANUP
cleanup() #{{{1
{
    # <doc:cleanup> {{{
    #
    # Cleans up any temp files lying around.
    # Intended to be used alongside tempfile() and not to be called directly.
    #
    # </doc:cleanup> }}}

    for file in "${CLEANUP_FILES[@]}"; do
        $SUDO rm -rf "$file"
    done
}
#endif
