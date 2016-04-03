#include "./lib/gpp-bashful-utils/gpp-squeeze_lines.sh"
#ifndeff EMBEDDED
#define EMBEDDED
embedded() #{{{1
{
    local c="#$1"; c="^[[:space:]]*$c[[:space:]]*"
    sed -n "/$c/p" "$@" | sed "s/$c//" | squeeze_lines
}
#endif
