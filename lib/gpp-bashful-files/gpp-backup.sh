#ifndef BACKUP
#define BACKUP
backup() #{{{1
{
    # <doc:backup> {{{
    #
    # Backup a file/directory with a timestamp.
    #
    # Usage: backup PATH [DIRECTORY]
    #
    # </doc:backup> }}}

    local f=$1; [[ -z $f || ! -f $f ]] && return 1
    local d=$2; [[ -z $d ]] && d=$(dirname "$f")
    mkdir -p "$d"
    copy "$f" "$d/$TIMESTAMP/$(basename "$f")"
}
#endif
