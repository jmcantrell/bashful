#include "gpp-remove.sh"
#include "gpp-filename.sh"
#include "gpp-error.sh"
#ifndeff TRUNCATE
#define TRUNCATE
truncate() #{{{1
{
    # <doc:truncate> {{{
    #
    # Removes all similar unused files.
    # The only assumption is that the prefix is separated from the identifier
    # by a single hyphen (-).
    #
    # Usage: truncate PREFIX SUFFIX [EXCLUDED_PREFIX...]
    #
    # Usage examples:
    #
    # Given the following files:
    #
    #     file.txt -> file-c.txt
    #     file-a.txt
    #     file-b.txt
    #     file-c.txt
    #
    # The following command:
    #
    #     truncate file .txt
    #
    # Will leave only the following files:
    #
    #     file.txt -> file-c.txt
    #     file-c.txt
    #
    # If you have other files with similar prefixes they will be removed as
    # well. For example, if we also had the following files:
    #
    #     file-foo-a.txt
    #     file-foo-b.txt
    #     file-bar-a.txt
    #     file-bar-b.txt
    #
    # If you want to keep these files, you will have to pass exclusions like:
    #
    #     truncate file .txt file-foo file-bar
    #
    # </doc:truncate> }}}

    local prefix=$1; shift
    local suffix=$1; shift
    local filename=$prefix$suffix

    # There is no symlink to follow
    if [[ ! -L $filename ]]; then
        error "Name not provided or does not exist as a symlink."
        return 1
    fi

    # Get the file to NOT remove
    local target=$(readlink -f "$filename")

    if [[ ! -e $target ]]; then
        error "Target file does not exist."
        return 1
    fi

    local dir=$(dirname "$target")
    local file fn exclude

    for file in "$dir"/$(basename "$prefix")-*$suffix; do
        [[ -f $file ]] || continue
        fn=${file##*/}
        # Make sure file doesn't match an exclusion
        for exclude in "$@"; do
            [[ $fn == $exclude* ]] && continue
        done
        if [[ $file != $target ]]; then
            remove "$file"
        fi
    done
}
#endif
