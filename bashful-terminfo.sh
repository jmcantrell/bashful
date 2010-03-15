#!/bin/bash

# Filename:      bashful-terminfo.sh
# Description:   Sets terminal strings for things like color, bold, etc.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-03-15 03:24:00 (-0400)

# doc bashful-terminfo {{{
#
# The terminfo library provides variables for altering the appearance of
# terminal output (bold, standout, underline, colors, etc).
#
# doc-end bashful-terminfo }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_TERMINFO_LOADED ]] && return

term_colors=$(tput colors)

P() { echo "${1}${2}${term_reset}"; }

C()
{
    local name="term_${1}g_$2"
    if [[ ! ${!name} ]] && (( $term_colors >= 8 )); then
        eval "$name=\"$(tput seta$1 $2)\""
    fi
    echo "${!name}${2}${term_reset}"
}

FG() { C f "$1" "$2"; }
BG() { C b "$1" "$2"; }

FX() { P "$(named "term_$1")" "$2"; }

term_reset=$(tput sgr0)
term_bold=$(tput bold)
term_dim=$(tput dim)
term_standout=$(tput smso)
term_italic=$(tput sitm)
term_underline=$(tput smul)
term_blink=$(tput blink)
term_reverse=$(tput rev)

if (( $term_colors >= 8 )); then
    # Foreground colors
    term_fg_black=$(tput setaf 0)
    term_fg_red=$(tput setaf 1)
    term_fg_green=$(tput setaf 2)
    term_fg_yellow=$(tput setaf 3)
    term_fg_blue=$(tput setaf 4)
    term_fg_magenta=$(tput setaf 5)
    term_fg_cyan=$(tput setaf 6)
    term_fg_white=$(tput setaf 7)
    # Background colors
    term_bg_black=$(tput setab 0)
    term_bg_red=$(tput setab 1)
    term_bg_green=$(tput setab 2)
    term_bg_yellow=$(tput setab 3)
    term_bg_blue=$(tput setab 4)
    term_bg_magenta=$(tput setab 5)
    term_bg_cyan=$(tput setab 6)
    term_bg_white=$(tput setab 7)
fi

BASHFUL_TERMINFO_LOADED=1
