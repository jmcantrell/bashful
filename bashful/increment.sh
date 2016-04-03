#ifndef INCREMENT
#define INCREMENT
increment() #{{{1
{
    # <doc:increment> {{{
    #
    # Get the next filename in line for the given file.
    #
    # Usage: increment FILENAME
    #
    # Usage examples:
    #     increment does_not_exist  #==> does_not_exist
    #     increment does_exist      #==> does_exist (1)
    #     increment does_exist      #==> does_exist (2)
    #
    # </doc:increment> }}}

    local file=$1
    local count=1
    local pattern=${2:- (\{num\})}

    while [[ -e $file ]]; do
        file="${1}${pattern//\{num\}/$((count++))}"
    done

    echo "$file"
}
#endif
