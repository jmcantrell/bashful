#ifndeff LINES
#define LINES
lines() #{{{1
{
    # <doc:lines>
    #
    # Get all lines except for comments and blank lines.
    #
    # Usage: lines [FILE...]
    #
    # </doc:lines>

    grep -E -v '^[[:space:]]*#|^[[:space:]]*$' "$@"
}
#endif
