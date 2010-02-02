#!/bin/bash

# Filename:      bashutils.sh
# Description:   An interface to bashutils for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-02-01 21:46:00 (-0500)

# This can be handy for using bashutils functionality in non-bash shell
# scripts. It's also useful for testing without having an existing script.
#
# Usage examples:
#     bashutils error "This is the error function."
#     bashutils input -p "Enter something"

source bashutils-files
source bashutils-input
source bashutils-messages
source bashutils-modes
source bashutils-profile
source bashutils-terminfo
source bashutils-utils

"$@"
