#!/bin/bash

# Filename:      bashutils.bash
# Description:   Various commonly used functions for Bash
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Sat 2009-10-31 15:35:31 (-0400)

usage_exit() #{{{1
{
    # Display usage information and exit with the given error code.
    # Will automatically populate certain sections if things like verbose or
    # interactive modes are set (either on or off).

    local error=${1:-0}

    if [[ $SCRIPT_NAME ]]; then
        {
            echo "Usage: $SCRIPT_NAME [OPTIONS] $SCRIPT_ARGS"
            [[ $SCRIPT_USAGE ]] && echo "$SCRIPT_USAGE"

            echo
            echo "GENERAL OPTIONS"
            echo
            echo "    -h    Display this help message."

            if [[ $INTERACTIVE ]]; then
                echo
                echo "    -i    Interactive. Prompt for certain actions."
                echo "    -f    Don't prompt."
            fi

            if [[ $VERBOSE ]]; then
                echo
                echo "    -v    Be verbose."
                echo "    -q    Be quiet."
            fi

            if [[ $SCRIPT_OPTIONS ]]; then
                echo
                echo "APPLICATION OPTIONS"
                echo
                squeeze_lines "$SCRIPT_OPTIONS" | sed 's/^/    /'
            fi
        } >&2
    fi

    exit $error
}

error_exit() #{{{1
{
    # Displays an error message and exits with the given error code.

    msg_error "$1"
    exit ${2:-1}
}

terminfo() #{{{1
{
    # Sets a bunch of terminal strings for things like color, bold, italics,
    # underline, and blinking.

    truth $terminfo_loaded && return

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

    terminfo_loaded=1
}

extname() #{{{1
{
    # Get the extension of the given filename.
    #
    # Usage examples:
    #     extname     foo.tar.gz  #==> gz
    #     extname -n2 foo.tar.gz  #==> tar.gz

    local levels=1

    unset OPTIND
    while getopts ":n:" options; do
        case $options in
            n) levels=$OPTARG ;;
        esac
    done && shift $(($OPTIND - 1))

    local filename=${1##*/}
    local fn=$filename
    local exts ext

    for i in $(seq 1 $levels); do
        ext=.${fn##*.}
        exts=$ext$exts
        fn=${fn%$ext}
        [[ $exts == .$filename ]] && return 1
    done

    echo "${exts##.}"
}

first() #{{{1
{
    # Get the first value that is non-empty.
    #
    # Usage example:
    #     EDITOR=$(first "$VISUAL" "$EDITOR" vi)

    local value
    for value in "$@"; do
        if [[ $value ]]; then
            echo "$value"
            return
        fi
    done
}

named() #{{{1
{
    # Get the value of the variable named by the given value.

    echo "${!1}"
}

truth() #{{{1
{
    # Determine the "truthiness" of the given value.
    #
    # Usage examples:
    #     truth True   #==> true
    #     truth        #==> false
    #     truth 1      #==> true
    #     truth false  #==> false
    #     truth on     #==> true
    #     truth spam   #==> false

    case $(tr A-Z a-z <<<"$1") in
        yes|y|true|t|on|1) return 0 ;;
    esac
    return 1
}

truth_value() #{{{1
{
    # Gets a value that represents the "truthiness" of the given value.

    truth $1 && echo 1 || echo 0
}

gui() #{{{1
{
    # With no arguments, test if gui mode is enabled.
    # With one argument, set gui mode to given value.
    # Will only enable gui mode if X is running.

    if (( $# == 0 )); then
        if [[ $DISPLAY ]]; then
            truth $SCRIPT_GUI && return 0
        fi
        return 1
    fi
    export SCRIPT_GUI=$(truth_value $1)
}

interactive() #{{{1
{
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.

    if (( $# == 0 )); then
        truth $SCRIPT_INTERACTIVE && return 0
        return 1
    fi
    export SCRIPT_INTERACTIVE=$(truth_value $1)
}

verbose() #{{{1
{
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.

    if (( $# == 0 )); then
        truth $SCRIPT_VERBOSE && return 0
        return 1
    fi
    export SCRIPT_VERBOSE=$(truth_value $1)
}

verbose_execute() #{{{1
{
    # Will execute the given command and only display the output if verbose
    # mode is enabled.

    if verbose; then
        "$@"
    else
        "$@" &>/dev/null
    fi
}
msg_error() #{{{1
{
    # Displays a colorized (if available) error message.
    # If used with -c, message will only display if verbose mode is enabled.

    local check

    unset OPTIND
    while getopts ":c" options; do
        case $options in
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! verbose; then
        return
    fi

    terminfo

    local msg=${1:-An error has occurred.}

    if gui; then
        zenity --error --text="$msg"
    else
        msg_info "${term_fg_red}${term_bold}ERROR: ${msg}${term_reset}"
    fi
}

msg_info() #{{{1
{
    # Displays a colorized (if available) informational message.
    # If used with -c, message will only display if verbose mode is enabled.

    local check

    unset OPTIND
    while getopts ":c" options; do
        case $options in
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! verbose; then
        return
    fi

    terminfo

    local msg=${1:-All updates are complete.}

    if gui; then
        zenity --info --text="$msg"
    else
        echo -e "${term_bold}${msg}${term_reset}" >&2
    fi
}

msg_warn() #{{{1
{
    # Displays a colorized (if available) warning message.
    # If used with -c, message will only display if verbose mode is enabled.

    local check

    unset OPTIND
    while getopts ":c" options; do
        case $options in
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! verbose; then
        return
    fi

    terminfo

    local msg=${1:-Are you sure you want to proceed?}

    if gui; then
        zenity --warning --text="$msg"
    else
        msg_info "${term_fg_yellow}${term_bold}WARNING: ${msg}${term_reset}"
    fi
}

input() #{{{1
{
    # Prompts the user to input text.
    #
    # Usage examples:
    #
    # If user presses enter with no response, foo is taken as the input:
    #     input -p "Enter value" -d foo
    #
    # User will only be prompted if interactive mode is enabled:
    #     input -c -p "Enter value"

    local prompt="Enter value"

    local default check secret reply

    unset OPTIND
    while getopts ":p:d:cs" options; do
        case $options in
            p) prompt=$OPTARG ;;
            d) default=$OPTARG ;;
            c) check=1 ;;
            s) secret=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $secret; then
        if gui; then
            secret="--hide-text"
        else
            secret="-s"
        fi
    fi

    if truth $check && ! interactive; then
        echo "$default"
        return
    fi

    if gui; then
        reply=$(zenity --entry $secret --entry-text="$default" \
            --title="$prompt" --text="$prompt:")
    else
        read -ep $secret "${prompt}${default:+ [$default]}: " reply
    fi

    echo "${reply:-$default}"
}

question() #{{{1
{
    # Prompts the user with a yes/no question.
    #
    # Usage examples:
    #
    # If user presses enter with no response, answer will be "yes"
    #     question -p "Continue?" -d1
    #
    # User will only be prompted if interactive mode is enabled:
    #     question -c -p "Continue?"

    prompt="Are you sure you want to proceed?"
    local default check reply choice

    unset OPTIND
    while getopts ":p:d:c" options; do
        case $options in
            p) prompt=$OPTARG ;;
            d) default=$OPTARG ;;
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! interactive; then
        return 0
    fi

    if truth "$default"; then
        default=y
    else
        default=n
    fi

    if ! gui; then
        prompt="$prompt [$(sed "s/\($default\)/\u\1/i" <<<"yn")]: "
    fi

    until [[ $choice ]]; do
        if gui; then
            if zenity --question --text="$prompt"; then
                choice=y
            else
                choice=n
            fi
        else
            read -e -n1 -p "$prompt" choice
        fi
        choice=$(first "$choice" "$default" | trim)
        case $choice in
            y|Y) choice=0 ;;
            n|N) choice=1 ;;
            *)
                msg_error "Invalid choice."
                unset choice
                ;;
        esac
    done

    return $choice
}

choice() #{{{1
{
    # Prompts the user to choose from a set of choices.
    #
    # Usage examples:
    #     choice -p "Choose your favorite color" red green blue

    local prompt="Select from these choices"
    local prompt check

    unset OPTIND
    while getopts ":p:c" options; do
        case $options in
            p) prompt=$OPTARG ;;
            c) check=1 ;;
        esac
    done && shift $(($OPTIND - 1))

    if truth $check && ! interactive; then
        return
    fi

    if gui; then
        printf "%s\n" "$@" |
        zenity --list --title="$prompt" --text="$prompt:" --column="Choices"
    else
        echo "$prompt:" >&2
        select choice in "$@"; do
            if [[ $choice ]]; then
                echo "$choice"
                break
            fi
        done
    fi
}

squeeze() #{{{1
{
    # Removes leading/trailing whitespace and condenses all other consecutive
    # whitespace into a single space.
    #
    # Usage examples:
    #     squeeze "  foo  bar   baz  "
    #     echo    "  foo  bar   baz  " | squeeze
    #
    # Both commands will produce the string:
    #     "foo bar baz"

    if (( $# > 0 )); then
        squeeze <<<"$*"
    else
        read value
        while [[ $value =~ "  " ]]; do
            value=${value//  / }
        done
        trim "$value"
    fi
}

squeeze_lines() #{{{1
{
    # Removes all leading/trailing blank lines and condenses all other
    # consecutive blank lines into a single blank line.

    if (( $# > 0 )); then
        squeeze_lines <<<"$@"
    else
        sed '/^[[:space:]]+$/s/.*//g' | cat -s | trim_lines
    fi
}

trim() #{{{1
{
    # Removes all leading/trailing whitespace
    #
    # Usage examples:
    #     trim "  foo  bar baz "
    #     echo "  foo  bar baz " | trim
    #
    # Both commands will produce the string:
    #     "foo  bar baz"

    if (( $# > 0 )); then
        trim <<<"$@"
    else
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    fi
}

trim_lines() #{{{1
{
    # Removes all leading/trailing blank lines.

    if (( $# > 0 )); then
        trim_lines <<<"$@"
    else
        sed ':a;$!{N;ba;};s/^[[:space:]]*\n//;s/\n[[:space:]]*$//'
    fi
}

sleep_until() #{{{1
{
    # Causes the running process to wait until the given date.
    # If the date is in the past, it immediately returns.

    local secs=$(($(date -d "$1" +%s) - $(date +%s)))
    (( secs > 0 )) && sleep $secs
}
