#!/usr/bin/env bash

# Filename:      bashful-core.sh
# Description:   All other bashful libs source me.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_CORE_LOADED ]] && return

# Nothing here yet. If this was installed using homebrew, then you will see
# some aliases below. This is so that users on OS X will be using GNU utils.

# __ALIASES__

BASHFUL_CORE_LOADED=1
