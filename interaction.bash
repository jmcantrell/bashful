#!/bin/bash

. messages
. modes
. utils

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
                error "Invalid choice."
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

