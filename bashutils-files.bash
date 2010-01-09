#!/bin/bash

# Filename:      bashutils-files.bash
# Description:   Miscellaneous utility functions for dealing with files.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Thu 2010-01-07 01:33:13 (-0500)

[[ $BASH_LINENO ]] || exit 1
[[ $BASHUTILS_FILES_LOADED ]] && return

source bashutils-messages
source bashutils-modes
source bashutils-utils

commonpath() #{{{1
{
    # Gets the common path of the paths passed on stdin.

    local i path compare prefix IFS
    local OIFS=$IFS

    if (( $# > 0 )); then
        for path in "$@"; do
            echo "$path"
        done | commonpath
        return
    fi

    while read path; do
        IFS=/
        path=($(trim "/" <<<"$(abspath "$path")"))
        IFS=$OIFS
        if [[ ! $prefix ]]; then
            prefix=("${path[@]}")
            continue
        fi
        i=0
        compare=()
        while true; do
            [[ ${path[$i]} || ${prefix[$i]} ]] || break
            [[ ${path[$i]} != ${prefix[$i]} ]] && break
            compare=("${compare[@]}" "${path[$((i++))]}")
        done
        prefix=("${compare[@]}")
        IFS=/
        echo "/${prefix[*]}"
        IFS=$OIFS
    done | tail -n1
}

extname() #{{{1
{
    # Get the extension of the given filename.
    #
    # Usage: extname [OPTIONS] FILENAME
    #
    # Usage examples:
    #     extname     foo.tar.gz  #==> .gz
    #     extname -n2 foo.tar.gz  #==> .tar.gz

    local levels=1

    unset OPTIND
    while getopts ":n:" options; do
        case $options in
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
    # Gets the filename of the given path.
    #
    # Usage: filename [OPTIONS] FILENAME
    #
    # Usage examples:
    #     filename /path/to/file.txt  #==> file

    local levels=1

    unset OPTIND
    while getopts ":n:" options; do
        case $options in
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
    # Get the next filename in line for the given file.
    #
    # Usage: increment_file FILENAME
    #
    # Usage examples:
    #     increment_file does_not_exist  #==> does_not_exist
    #     increment_file does_exist      #==> does_exist (1)

    local file=$1
    local count=1

    while [[ -e $file ]]; do
        file="$1 ($((count++)))"
    done

    echo "$file"
}

listdir() #{{{1
{
    # Get the files in the given directory (1 level deep).

    local dir=$1; shift
    find "$dir" -maxdepth 1 -mindepth 1 "$@"
}

mimetype() #{{{1
{
    # Get the mimetype of the given file.
    file -ibL "$1" | awk -F";" '{print $1}'
}

mount_file() #{{{1
{
    # Get the mount path that contains the given file.

    local f=$(readlink -f "$1")

    for m in $(mount | awk '{print $3}' | sort); do
        if [[ $f == $m/* ]]; then
            echo "$m"
        fi
    done | tail -n1
}

mount_path() #{{{1
{
    # Get the mount path for the given device.
    grep "^$(readlink -f "$1")[[:space:]]" /etc/fstab | awk '{print $2}'
}

mount_device() #{{{1
{
    # Get the device for the given mount path.
    grep "[[:space:]]$(readlink -f "$1")[[:space:]]" /etc/fstab | awk '{print $1}'
}

mounted_same() #{{{1
{
    # Determine if all given files are on the same mount path.

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
    # Check to see if a given device is mounted.
    mount | awk '{print $3}' | grep -q "^$(readlink -f "${1:-/}")$"
}

mounted_device() #{{{1
{
    # Check to see if a given device is mounted.
    mount | awk '{print $1}' | grep -q "^$(readlink -f "${1:-/}")$"
}

abspath() #{{{1
{
    # Gets the absolute path of the given path.

    local path=${1:-$PWD}
    [[ $path != /* ]] && path=$PWD/${path//\.\//\/}
    echo "/$(squeeze "/" <<<"$path")"
}

relpath() #{{{1
{
    # Gets the relative path from source to destination.
    #
    # Usage: relpath [DESTINATION] [SOURCE]
    #
    # Output should mirror the python function os.path.relpath().
    #
    # All arguments should be given as absolute paths.
    # All arguments default to the current directory.
    #
    # Usage examples:
    #
    #     relpath /home/user     /home/user/bin  #==> bin
    #     relpath /home/user/bin /home/user      #==> ..
    #     relpath /foo/bar/baz   /               #==> ../../..
    #     relpath /foo/bar       /baz            #==> ../../baz
    #     relpath /home/user     /home/user      #==> .

    # Make sure that any duplicate slashes are removed.
    local dst=/$(squeeze "/" <<<"${1:-$PWD}")
    local src=/$(squeeze "/" <<<"${2:-$PWD}")

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
    # Version of ln that respects the interactive/verbose settings.

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    ln -snT $(interactive_option) $(verbose_echo -v) "$@"
}

move() #{{{1
{
    # Version of mv that respects the interactive/verbose settings.

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    mv -T $(interactive_option) $(verbose_echo -v) "$@"
}

copy() #{{{1
{
    # Version of cp that respects the interactive/verbose settings.

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    cp -rT $(interactive_option) $(verbose_echo -v) "$@"
}

remove() #{{{1
{
    # Version of rm that respects the interactive/verbose settings.

    interactive ${INTERACTIVE:-1}
    verbose     ${VERBOSE:-1}

    rm -r $(interactive_option) $(verbose_echo -v) "$@"
}

trash() #{{{1
{
    # Put files in gnome trash if it's on the same partition.
    # If on a different partition, remove as normal.

    local td=$HOME/.local/share/Trash

    mkdir -p "$td/info"
    mkdir -p "$td/files"

    for f in "$@"; do
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

truncate() #{{{1
{
    # Removes all similar unused files.
    #
    # Usage: truncate PREFIX SUFFIX [EXCLUDED_PREFIX...]
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

BASHUTILS_FILES_LOADED=1
