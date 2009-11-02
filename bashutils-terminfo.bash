#!/bin/bash

# Sets a bunch of terminal strings for things like color, bold, italics,
# underline, and blinking.

[[ $BASH_LINENO ]] || exit 1
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
