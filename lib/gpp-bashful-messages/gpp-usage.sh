#ifndef USAGE
#define USAGE
usage() #{{{1
{
    # <doc:usage> {{{
    #
    # Display usage information and exit with the given error code.
    # Will automatically populate certain sections if things like verbose or
    # interactive modes are set (either on or off).
    #
    # Usage: usage [ERROR]
    #
    # Required variables:
    #
    #     SCRIPT_NAME
    #
    # Optional variables:
    #
    #     SCRIPT_ARGUMENTS
    #     SCRIPT_DESCRIPTION
    #     SCRIPT_EXAMPLES
    #     SCRIPT_OPTIONS
    #     SCRIPT_USAGE
    #
    # </doc:usage> }}}

    if [[ $SCRIPT_NAME ]]; then
        local p="    "
        {
            echo "Usage: $SCRIPT_NAME [OPTIONS] $SCRIPT_ARGUMENTS"
            [[ $SCRIPT_USAGE ]] && echo "$SCRIPT_USAGE"

            if [[ $SCRIPT_DESCRIPTION ]]; then
                echo
                echo -e "$SCRIPT_DESCRIPTION"
            fi

            if [[ $SCRIPT_EXAMPLES ]]; then
                echo
                echo "EXAMPLES"
                echo
                echo -e "$SCRIPT_EXAMPLES"
            fi

            echo
            echo "GENERAL OPTIONS"
            echo
            echo "${p}-h    Display this help message."

            if [[ $INTERACTIVE ]]; then
                echo
                echo "${p}-i    Interactive. Prompt for certain actions."
                echo "${p}-f    Don't prompt."
            fi

            if [[ $VERBOSE ]]; then
                echo
                echo "${p}-v    Be verbose."
                echo "${p}-q    Be quiet."
            fi

            if [[ $SCRIPT_OPTIONS ]]; then
                echo
                echo "APPLICATION OPTIONS"
                echo
                echo -e "$SCRIPT_OPTIONS" | sed "s/^/${p}/"
            fi
        } | squeeze_lines >&2
    fi

    exit ${1:-0}
}
#endif
