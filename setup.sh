#!/usr/bin/env bash

set -e

ME=${0##*/}
HERE=${0%/*}

DIRS=(
    'bin'
    'share/man/man1'
    'share/zsh/functions'
)

DESTDIR=${DESTDIR:-}
PREFIX=${PREFIX:-/usr/local}

USAGE="Usage: $ME install|uninstall"

if (( $# == 0 )); then
    echo "$USAGE"
    exit 1
fi

if [[ ! -d $PREFIX ]]; then
    echo "ERROR: Bad prefix '$PREFIX'"
    exit 1
fi

cd "$(dirname "$0")"

case $1 in
    uninstall)
        for dir in "${DIRS[@]}"; do
            for fn in "$HERE/$dir"/*; do
                rm -vf "$DESTDIR$PREFIX/$dir/${fn##*/}"
            done
        done
        ;;
    install)
        for dir in "${DIRS[@]}"; do
            mkdir -p "$DESTDIR$PREFIX/$dir"
            cp -v "$HERE/$dir"/* "$DESTDIR$PREFIX/$dir"
        done
        ;;
    *)
        echo "$USAGE"
        exit 1
        ;;
esac
