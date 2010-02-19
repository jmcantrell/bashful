#!/bin/bash

# Filename:    bashful-terminfo.sh
# Description: Sets terminal strings for things like color, bold, etc.
# Maintainer:  Jeremy Cantrell <jmcantrell@gmail.com>

# autodoc-begin bashful-terminfo {{{
#
# The terminfo library provides variables for altering the appearance of
# terminal output (bold, italics, underline, colors, etc).
#
# autodoc-end bashful-terminfo }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-autodoc
    autodoc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_TERMINFO_LOADED ]] && return

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

BASHFUL_TERMINFO_LOADED=1
