#!/usr/bin/env bash

set -e

NAME=bashful

# DESTDIR is provided for staged installs (used for packagers only)
DESTDIR=${DESTDIR:-}
PREFIX=${PREFIX:-/usr/local}

BINDIR="${DESTDIR}${PREFIX}/bin"
MANDIR="${DESTDIR}${PREFIX}/share/man/man1"

USAGE="Usage: setup.sh install|uninstall"

CP='cp -v'
RM='rm -vf'
LN_S='ln -vsf'

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
        $RM "$BINDIR"/bashful*
        $RM "$MANDIR"/bashful*.1
        ;;
    install)
        mkdir -p "$BINDIR" "$MANDIR"
        $CP bin/bashful* "$BINDIR"
        $CP share/man/man1/bashful*.1 "$MANDIR"
        ;;
    *)
        echo "$USAGE"
        exit 1
        ;;
esac
