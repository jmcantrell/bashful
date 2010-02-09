#!/bin/bash

# Filename:      bashutils.sh
# Description:   An interface to bashutils for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Tue 2010-02-09 00:48:13 (-0500)

# autodoc-begin bashutils {{{
#
# This can be handy for using bashutils functionality in non-bash shell
# scripts. It's also useful for testing without having an existing script.
#
# To get documentation:
#
#     bashutils help
#     bashutils help [COMMAND]
#
# To get documentation for a specific library:
#
#     bashutils-input help
#     bashutils-input help [COMMAND]
#
# Usage examples (from command line or non-bash shell):
#
#     bashutils error "This is the error function."
#     bashutils input -p "Enter something"
#
# Usage examples (from within a bash script):
#
#     source bashutils-messages
#     error "This is the error function."
#
#     source bashutils-input
#     input -p "Enter something"
#
# autodoc-end bashutils }}}

LIBS=(
    bashutils-files
    bashutils-input
    bashutils-messages
    bashutils-modes
    bashutils-profile
    bashutils-terminfo
    bashutils-utils
    )

LIB_FILES=($(type -p bashutils))

for lib in "${LIBS[@]}"; do
    LIB_FILES=("${LIB_FILES[@]}" "$(type -p "$lib")")
    source "$lib"
done

if [[ ! $1 || $1 == help ]]; then
    if [[ $2 ]]; then
        autodoc "$2" "${LIB_FILES[@]}" >&2
    else
        {
            autodoc bashutils "$0"
            echo -e "\nAvailable libraries:\n"
            OIFS=$IFS; IFS=$'\n'
            echo "${LIBS[*]}" | sort -u | sed 's/^/    /'
            IFS=$OIFS
            echo -e "\nAvailable commands:\n"
            autodoc_commands "${LIB_FILES[@]}" | sed 's/^/    /'
        } >&2
    fi
    exit
fi

"$@"
