#!/bin/bash

# Filename:      bashutils.bash
# Description:   An interface to bashutils for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Sat 2009-11-07 22:41:49 (-0500)

# This can be handy for using bashutils functionality in non-bash shell
# scripts. It's also useful for debugging bashutils without having an existing
# script.
#
# Usage examples:
#
#     bashutils error "This is the error function from bashutils-messages"

source bashutils-input
source bashutils-messages
source bashutils-modes
source bashutils-profile
source bashutils-terminfo
source bashutils-utils

"$@"
