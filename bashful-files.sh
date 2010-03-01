#!/bin/bash

# Filename:      bashful-files.sh
# Description:   Miscellaneous utility functions for dealing with files.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-03-01 00:13:32 (-0500)

# doc bashful-files {{{
#
# The files library provides functions for working with files/directories.
#
# doc-end bashful-files }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_FILES_LOADED ]] && return

source bashful-messages
source bashful-modes
source bashful-utils

commonpath() #{{{1
{
    # doc commonpath {{{
    #
    # Usage: commonpath [PATH...]
    # Gets the common path of the paths passed on stdin.
    # Alternatively, paths can be passed as arguments.
    #
    # doc-end commonpath }}}

    local path

    # Make sure command line args go to stdin
    if (( $# > 0 )); then
        for path in "$@"; do
            echo "$path"
        done | commonpath
        return
    fi

    local prefix=$(
        while read -r; do
            echo "$(abspath "$REPLY")/"
        done | commonprefix
    )

    # We only want to break at path separators
    if [[ $prefix != */ ]]; then
        prefix=${prefix%/*}/
    fi

    # Only strip the trailing slash if it's not root (/)
    if [[ $prefix != / ]]; then
        prefix=${prefix%/}
    fi

    echo "$prefix"
}

extname() #{{{1
{
    # doc extname {{{
    #
    # Usage: extname [-n LEVELS] FILENAME
    # Get the extension of the given filename.
    #
    # Usage examples:
    #     extname     foo.tar.gz  #==> .gz
    #     extname -n2 foo.tar.gz  #==> .tar.gz
    #
    # doc-end extname }}}

    local levels=1

    unset OPTIND
    while getopts ":n:" option; do
        case $option in
            n) levels=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    local filename=${1##*/}
    local fn=$filename
    local exts ext

    for i in $(seq 1 $levels); do
        ext=.${fn##*.}
        exts=$ext$exts
        fn=${fn%$ext}
        [[ $exts == $filename ]] && return 1
    done

    echo "$exts"
}

filename() #{{{1
{
    # doc filename {{{
    #
    # Usage: filename [-n LEVELS] FILENAME
    # Gets the filename of the given path.
    #
    # Usage examples:
    #     filename     /path/to/file.txt     #==> file
    #     filename -n2 /path/to/file.tar.gz  #==> file
    #
    # doc-end filename }}}

    local levels=1

    unset OPTIND
    while getopts ":n:" option; do
        case $option in
            n) levels=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    local ext=$(extname -n $levels "$1")

    if [[ $ext ]]; then
        basename "$1" $ext
    else
        basename "$1"
    fi
}

increment_file() #{{{1
{
    # doc increment_file {{{
    #
    # Usage: increment_file FILENAME
    # Get the next filename in line for the given file.
    #
    # Usage examples:
    #     increment_file does_not_exist  #==> does_not_exist
    #     increment_file does_exist      #==> does_exist (1)
    #
    # doc-end increment_file }}}

    local file=$1
    local count=1

    while [[ -e $file ]]; do
        file="$1 ($((count++)))"
    done

    echo "$file"
}

listdir() #{{{1
{
    # doc listdir {{{
    #
    # Usage: listdir DIR [OPTIONS]
    # List the files in the given directory (1 level deep).
    # Accepts the same options as the find command.
    #
    # doc-end listdir }}}

    local dir=$1; shift
    find "$dir" -maxdepth 1 -mindepth 1 "$@"
}

mimetype() #{{{1
{
    # doc mimetype {{{
    #
    # Usage: mimetype FILE
    # Get the mimetype of the given file.
    #
    # doc-end mimetype }}}

    file -ibL "$1" | awk -F";" '{print $1}'
}

mount_file() #{{{1
{
    # doc mount_file {{{
    #
    # Usage: mount_file FILE
    # Get the mount path that contains the given file.
    #
    # doc-end mount_file }}}

    local f=$(readlink -f "$1")

    for m in $(mount | awk '{print $3}' | sort); do
        if [[ $f == $m/* ]]; then
            echo "$m"
        fi
    done | tail -n1
}

mount_path() #{{{1
{
    # doc mount_path {{{
    #
    # Usage: mount_device DEVICE
    # Get the mount path for the given device.
    #
    # doc-end mount_path }}}

    grep "^$(readlink -f "$1")[[:space:]]" /etc/fstab | awk '{print $2}'
}

mount_device() #{{{1
{
    # doc mount_device {{{
    #
    # Usage: mount_device PATH
    # Get the device for the given mount path.
    #
    # doc-end mount_device }}}

    grep "[[:space:]]$(readlink -f "$1")[[:space:]]" /etc/fstab |
    awk '{print $1}'
}

mounted_same() #{{{1
{
    # doc mounted_same {{{
    #
    # Usage: mounted_same [FILE...]
    # Determine if all given files are on the same mount path.
    #
    # doc-end mounted_same }}}

    local prev cur

    for f in "$@"; do
        cur=$(mount_file "$f")
        [[ $prev && $cur != $prev ]] && return 1
        prev=$cur
    done

    return 0
}

mounted_path() #{{{1
{
    # doc mounted_path {{{
    #
    # Usage: mounted_path [PATH]
    # Check to see if a given path is mounted.
    #
    # doc-end mounted_path }}}

    mount | awk '{print $3}' | grep -q "^$(readlink -f "${1:-/}")$"
}

mounted_device() #{{{1
{
    # doc mounted_device {{{
    #
    # Usage: mounted_device DEVICE
    # Check to see if a given device is mounted.
    #
    # doc-end mounted_device }}}

    mount | awk '{print $1}' | grep -q "^$(readlink -f "${1:-/}")$"
}

abspath() #{{{1
{
    # doc abspath {{{
    #
    # Usage: abspath [PATH]
    # Gets the absolute path of the given path.
    # Will resolve paths that contain '.' and '..'.
    #
    # doc-end abspath }}}

    local path=${1:-$PWD}

    # Path looks like: ~user/...
    if [[ $path =~ ~[a-zA-Z] ]]; then
        local name=${path##\~}
        name=${name%%/*}
        local home=$(grep "^$name:" /etc/passwd | awk -F: '{print $6}')
        path=${path/~$name/$home}
    fi

    # Path looks like: ~/...
    [[ $path == ~* ]] && path=${path/\~/$HOME}

    [[ $path == /*  ]] || path=$PWD/$path

    path=$(squeeze "/" <<<"$path")

    local elms=()
    local elm
    OIFS=$IFS; IFS="/"
    for elm in $path; do
        IFS=$OIFS
        [[ $elm == . ]] && continue
        if [[ $elm == .. ]]; then
            elms=("${elms[@]:0:$((${#elms[@]}-1))}")
        else
            elms=("${elms[@]}" "$elm")
        fi
    done
    IFS="/"
    echo "/${elms[*]}"
    IFS=$OIFS
}

relpath() #{{{1
{
    # doc relpath {{{
    #
    # Usage: relpath [DESTINATION] [SOURCE]
    # Gets the relative path from SOURCE to DESTINATION.
    # Output should mirror the python function os.path.relpath().
    # All arguments default to the current directory.
    #
    # Usage examples:
    #     relpath /home/user     /home/user/bin  #==> bin
    #     relpath /home/user/bin /home/user      #==> ..
    #     relpath /foo/bar/baz   /               #==> ../../..
    #     relpath /foo/bar       /baz            #==> ../../baz
    #     relpath /home/user     /home/user      #==> .
    #
    # doc-end relpath }}}

    local dst=$(abspath "$1")
    local src=$(abspath "$2")

    local common=$(commonpath "$dst" "$src")

    dst=${dst#$common}; dst=${dst#/}
    src=${src#$common}; src=${src#/}

    local OIFS=$IFS; local IFS=/
    src=($src)
    IFS=$OIFS

    local rel=
    for i in "${!src[@]}"; do
        rel+=../
    done

    rel=${rel}${dst}

    # Handle some corner cases.
    # Arguments were the same path.
    [[ $rel ]] || rel=.
    # Make sure there are no trailing slashes.
    # ...except for root.
    [[ $rel == / ]] || rel=${rel%%/}

    echo "$rel"
}

link() #{{{1
{
    # doc link {{{
    #
    # Usage: link SOURCE [DESTINATION]
    # Version of ln that respects the interactive/verbose settings.
    # Accepts the same options/arguments as ln.
    #
    # doc-end link }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    ln -snT $(interactive_option) $(verbose_echo -v) "$1" "${2:-$(basename "$1")}"
}

move() #{{{1
{
    # doc move {{{
    #
    # Version of mv that respects the interactive/verbose settings.
    # Accepts the same options/arguments as mv.
    #
    # doc-end name }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    mv -T $(interactive_option) $(verbose_echo -v) "$@"
}

copy() #{{{1
{
    # doc copy {{{
    #
    # Version of cp that respects the interactive/verbose settings.
    # Accepts the same options/arguments as cp.
    #
    # doc-end copy }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    cp -rT $(interactive_option) $(verbose_echo -v) "$@"
}

remove() #{{{1
{
    # doc remove {{{
    #
    # Version of rm that respects the interactive/verbose settings.
    # Accepts the same options/arguments as rm.
    #
    # doc-end remove }}}

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    rm -r $(interactive_option) $(verbose_echo -v) "$@"
}

trash() #{{{1
{
    # doc trash {{{
    #
    # Usage: trash [FILE...]
    # Put files in gnome trash if it's on the same partition.
    # If on a different partition, remove as normal.
    #
    # doc-end trash }}}

    local td=$HOME/.local/share/Trash

    mkdir -p "$td/info"
    mkdir -p "$td/files"

    for f in "$@"; do
        [[ -e $f ]] || continue
        if mounted_same "$td" "$f"; then
            {
                echo "[Trash Info]"
                echo "Path=$(readlink -f "$f")"
                echo "DeletionDate=$(date)"
            } >$td/info/${f##*/}.trashinfo
            move "$f" "$td/files"
        else
            remove "$f"
        fi
    done
}

cleanup() #{{{1
{
    # doc cleanup {{{
    #
    # Cleans up any temp files lying around.
    # Intended to be used alongside tempfile() and not to be called directly.
    #
    # doc-end cleanup }}}

    for file in "${CLEANUP_FILES[@]}"; do
        rm -rf "$file"
    done
}

tempfile() #{{{1
{
    # doc tempfile {{{
    #
    # Creates and keeps track of temp files/dirs.
    # Accepts the same options/arguments as mktemp.
    #
    # Usage examples:
    #     tempfile     # $TEMPFILE is now a regular file
    #     tempfile -d  # $TEMPFILE is now a directory
    #
    # doc-end tempfile }}}

    TEMPFILE=$(mktemp "$@")
    if [[ ! $TEMPFILE ]]; then
        error "Could not create temp file."
        return 1
    fi
    CLEANUP_FILES=("${CLEANUP_FILES[@]}" "$TEMPFILE")
    trap cleanup INT TERM EXIT
}

truncate() #{{{1
{
    # doc truncate {{{
    #
    # Usage: truncate PREFIX SUFFIX [EXCLUDED_PREFIX...]
    # Removes all similar unused files.
    #
    # The only assumption is that the prefix is separated from the identifier
    # by a single hyphen (-).
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
    # doc-end truncate }}}

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

#}}}1

BASHFUL_FILES_LOADED=1
