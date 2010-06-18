#!/usr/bin/env bash

# Filename:      bashful.sh
# Description:   An interface to bashful for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Wed 2010-06-16 00:54:29 (-0400)

(( ${BASH_LINENO:-0} > 0 )) && exit

source bashful-doc
source bashful-execute
source bashful-files
source bashful-input
source bashful-messages
source bashful-modes
source bashful-profile
source bashful-terminfo
source bashful-utils

"$@"
