#!/bin/bash

# Filename:      bashutils.bash
# Description:   An interface to bashutils for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Sat 2009-12-12 23:35:32 (-0500)

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
