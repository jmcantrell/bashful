#include "1459669815-tmp/gpp-P.sh"
#ifndeff C
#define C
C()
{
    local name="term_${1}g_$(printf "%03d" "$((10#$2))")"
    if [[ ! ${!name} ]] && (( $term_colors >= 8 )); then
        eval "$name=\"$(tput seta$1 $2)\""
    fi
    P "${!name}" "$3"
}
#endif
#ifndeff C
#define C
C()
{
    local name="term_${1}g_$(printf "%03d" "$((10#$2))")"
    if [[ ! ${!name} ]] && (( $term_colors >= 8 )); then
        eval "$name=\"$(tput seta$1 $2)\""
    fi
    P "${!name}" "$3"
}
#endif
