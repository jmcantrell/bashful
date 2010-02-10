#!/bin/bash

# Filename:      bashutils.sh
# Description:   An interface to bashutils for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Wed 2010-02-10 00:20:29 (-0500)

(( ${BASH_LINENO:-0} > 0 )) && exit

source bashutils-autodoc
source bashutils-files
source bashutils-input
source bashutils-messages
source bashutils-modes
source bashutils-profile
source bashutils-terminfo
source bashutils-utils

"$@"
