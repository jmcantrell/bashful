#!/usr/bin/env bash

# Filename:      bashful.sh
# Description:   An interface to bashful for non-bash scripts.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-09-27 20:18:45 (-0400)

(( ${BASH_LINENO:-0} > 0 )) && exit

source bashful-core
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
