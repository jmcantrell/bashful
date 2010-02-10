#!/bin/bash

# Filename:      bashutils-terminfo.sh
# Description:   Sets terminal strings for things like color, bold, etc.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Tue 2010-02-09 23:47:47 (-0500)

# autodoc-begin bashutils-autodoc {{{
#
# The autodoc library provides a way to extract documentation from scripts.
#
# Normally, I would prefer to use getopts to setup a -h/--help option, but in
# some cases it isn't practical or it can conflict with other functions. This
# provides a nice alternative with no side-effects.
#
# Within the script, a section of documentation is denoted like this:
#
#     # autodoc-begin NAME
#     #
#     # DOCUMENTATION TEXT GOES HERE
#     #
#     # autodoc-end NAME
#
# autodoc-end bashutils-autodoc }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashutils-autodoc
    autodoc_execute "$0" "$@"
    exit
fi

[[ $BASHUTILS_TERMINFO_LOADED ]] && return

term_reset=$(tput sgr0 2>/dev/null)
term_bold=$(tput bold 2>/dev/null)
term_italics=$(tput sitm 2>/dev/null)
term_underline=$(tput smul 2>/dev/null)
term_blink=$(tput blink 2>/dev/null)

if (( $(tput colors) >= 8 )); then
    # Foreground colors
    term_fg_black=$(tput setaf 0 2>/dev/null)
    term_fg_red=$(tput setaf 1 2>/dev/null)
    term_fg_green=$(tput setaf 2 2>/dev/null)
    term_fg_yellow=$(tput setaf 3 2>/dev/null)
    term_fg_blue=$(tput setaf 4 2>/dev/null)
    term_fg_magenta=$(tput setaf 5 2>/dev/null)
    term_fg_cyan=$(tput setaf 6 2>/dev/null)
    term_fg_white=$(tput setaf 7 2>/dev/null)
    # Background colors
    term_bg_black=$(tput setbf 0 2>/dev/null)
    term_bg_red=$(tput setbf 1 2>/dev/null)
    term_bg_green=$(tput setbf 2 2>/dev/null)
    term_bg_yellow=$(tput setbf 3 2>/dev/null)
    term_bg_blue=$(tput setbf 4 2>/dev/null)
    term_bg_magenta=$(tput setbf 5 2>/dev/null)
    term_bg_cyan=$(tput setbf 6 2>/dev/null)
    term_bg_white=$(tput setbf 7 2>/dev/null)
fi

BASHUTILS_TERMINFO_LOADED=1
