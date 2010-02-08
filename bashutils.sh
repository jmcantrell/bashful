#!/bin/bash

# Filename:      bashutils.sh
# Description:   An interface to bashutils for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-02-08 00:25:41 (-0500)

# This can be handy for using bashutils functionality in non-bash shell
# scripts. It's also useful for testing without having an existing script.
#
# Usage examples:
#     bashutils error "This is the error function."
#     bashutils input -p "Enter something"

LIBS=(
    bashutils-files
    bashutils-input
    bashutils-messages
    bashutils-modes
    bashutils-profile
    bashutils-terminfo
    bashutils-utils
    )

LIB_FILES=()

for lib in "${LIBS[@]}"; do
    LIB_FILES=("${LIB_FILES[@]}" "$(type -p "$lib")")
    source "$lib"
done

if [[ ! $1 || $1 == help ]]; then
    if [[ ! $2 ]]; then
        {
            echo "Usage: $(basename "$0" .sh) [COMMAND] [ARGS...]"
            echo "Access bashutils without sourcing individual libraries."
            echo
            echo "    help            To see available commands."
            echo "    help COMMAND    To see help for COMMAND."
            echo
            echo "Where COMMAND is one of the following:"
            echo
        } >&2
        for f in "${LIB_FILES[@]}"; do
            lines "$f" | functions
        done | sort -u | sed 's/^/    /'
    else
        for f in "${LIB_FILES[@]}"; do
            sed -n "/doc-$2$/,/^doc-$2/p" "$f" | sed "/doc-$2/d"
        done
    fi
    exit
fi

"$@"
