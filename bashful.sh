#!/bin/bash

# Filename:    bashful.sh
# Description: An interface to bashful for non-bash scripts.
# Maintainer:  Jeremy Cantrell <jmcantrell@gmail.com>

(( ${BASH_LINENO:-0} > 0 )) && exit

source bashful-autodoc
source bashful-files
source bashful-input
source bashful-messages
source bashful-modes
source bashful-profile
source bashful-terminfo
source bashful-utils

"$@"
