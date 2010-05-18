#!/bin/bash

# Filename:      bashful-files.sh
# Description:   Miscellaneous utility functions for dealing with files.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Tue 2010-05-18 19:42:28 (-0400)

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
    # Gets the common path of the paths passed on stdin.
    # Alternatively, paths can be passed as arguments.
    #
    # Usage: commonpath [PATH...]
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
    # doc-end extname }}}

    local levels

    unset OPTIND
    while getopts ":n:" option; do
        case $option in
            n) levels=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    local filename=${1##*/}
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
        [[ $exts == $filename ]] && return 1
    done

    echo "$exts"
}

filename() #{{{1
{
    # doc filename {{{
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
    # doc-end filename }}}

    local ext=$(extname "$@")

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
    # Get the next filename in line for the given file.
    #
    # Usage: increment_file FILENAME
    #
    # Usage examples:
    #     increment_file does_not_exist  #==> does_not_exist
    #     increment_file does_exist      #==> does_exist (1)
    #     increment_file does_exist      #==> does_exist (2)
    #
    # doc-end increment_file }}}

    local file=$1
    local count=1
    local pattern=${2:- (\{num\})}

    while [[ -e $file ]]; do
        file="${1}${pattern//\{num\}/$((count++))}"
    done

    echo "$file"
}

listdir() #{{{1
{
    # doc listdir {{{
    #
    # List the files in the given directory (1 level deep).
    # Accepts the same options as the find command.
    #
    # Usage: listdir DIR [OPTIONS]
    #
    # doc-end listdir }}}

    local dir=$1; shift
    find "$dir" -maxdepth 1 -mindepth 1 "$@"
}

mimetype() #{{{1
{
    # doc mimetype {{{
    #
    # Get the mimetype of the given file.
    #
    # Usage: mimetype FILE
    #
    # doc-end mimetype }}}

    file -ibL "$1" | awk -F";" '{print $1}'
}

mount_file() #{{{1
{
    # doc mount_file {{{
    #
    # Get the mount path that contains the given file.
    #
    # Usage: mount_file FILE
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
    # Get the mount path for the given device.
    #
    # Usage: mount_device DEVICE
    #
    # doc-end mount_path }}}

    grep "^$(readlink -f "$1")[[:space:]]" /etc/fstab | awk '{print $2}'
}

mount_device() #{{{1
{
    # doc mount_device {{{
    #
    # Get the device for the given mount path.
    #
    # Usage: mount_device PATH
    #
    # doc-end mount_device }}}

    grep "[[:space:]]$(readlink -f "$1")[[:space:]]" /etc/fstab | awk '{print $1}'
}

mounted_same() #{{{1
{
    # doc mounted_same {{{
    #
    # Determine if all given files are on the same mount path.
    #
    # Usage: mounted_same [FILE...]
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
    # Check to see if a given path is mounted.
    #
    # Usage: mounted_path [PATH]
    #
    # doc-end mounted_path }}}

    mount | awk '{print $3}' | grep -q "^$(readlink -f "${1:-/}")$"
}

mounted_device() #{{{1
{
    # doc mounted_device {{{
    #
    # Check to see if a given device is mounted.
    #
    # Usage: mounted_device DEVICE
    #
    # doc-end mounted_device }}}

    mount | awk '{print $1}' | grep -q "^$(readlink -f "${1:-/}")$"
}

abspath() #{{{1
{
    # doc abspath {{{
    #
    # Gets the absolute path of the given path.
    # Will resolve paths that contain '.' and '..'.
    # Think readlink without the symlink resolution.
    #
    # Usage: abspath [PATH]
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
    # Gets the relative path from SOURCE to DESTINATION.
    # Output should mirror the python function os.path.relpath().
    # All arguments default to the current directory.
    #
    # Usage: relpath [DESTINATION] [SOURCE]
    #
    # Usage examples:
    #     relpath /home/user     /home/user/bin  #==> bin
    #     relpath /home/user/bin /home/user      #==> ..
    #     relpath /foo/bar/baz   /               #==> ../../..
    #     relpath /foo/bar       /baz            #==> ../../baz
    #     relpath /home/user     /home/user      #==> .
    #     relpath                                #==> .
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
    # Version of ln that respects the interactive/verbose settings.
    #
    # Usage: link SOURCE [DESTINATION]
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
    # Put files in gnome trash if it's on the same partition.
    # If on a different partition, remove as normal.
    #
    # Usage: trash [FILE...]
    #
    # doc-end trash }}}

    local td=$HOME/.local/share/Trash

    mkdir -p "$td/info"
    mkdir -p "$td/files"

    for f in "$@"; do
        [[ -e $f ]] || continue
        # Only trash files if they are on the same partition
        if mounted_same "$td" "$f"; then
            nf=$(increment_file "${f##*/}" ".{num}")
            {
                echo "[Trash Info]"
                echo "Path=$(readlink -f "$f")"
                echo "DeletionDate=$(date)"
            } >$td/info/$nf.trashinfo
            move "$f" "$td/files/$nf"
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
