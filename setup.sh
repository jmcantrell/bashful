#!/usr/bin/env bash

set -e

HERE=$(dirname "$0")

DESTDIR=${DESTDIR:-}
PREFIX=${PREFIX:-/usr/local}

BINDIR="${DESTDIR}${PREFIX}/bin"
MANDIR="${DESTDIR}${PREFIX}/share/man/man1"

USAGE="Usage: setup.sh install|uninstall"

if (( $# == 0 )); then
    echo "$USAGE"
    exit 1
fi

if [[ -n $DESTDIR && ! -d $DESTDIR ]]; then
    mkdir -p "$DESTDIR"
fi

if [[ ! -d $PREFIX ]]; then
    echo "ERROR: Bad prefix '$PREFIX'"
    exit 1
fi

cd "$(dirname "$0")"

case $1 in
    uninstall)
        for fn in $HERE/bin/* $HERE/share/man/man1/*; do
            rm -rf "$fn"
        done
        ;;
    install)
        mkdir -p "$BINDIR" "$MANDIR"
        cp -v $HERE/bin/* "$BINDIR"
        cp -v $HERE/share/man/man1/* "$MANDIR"
        ;;
    *)
        echo "$USAGE"
        exit 1
        ;;
esac
