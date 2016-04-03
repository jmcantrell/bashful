Bashful-GPP
===========
> the functions in bashful seporated into their own files and wraped in gpp macros  

Bashful is an incredable library, but It has alot of overhead. I often need just a single function and its dependencies, but end up having to source way more than my program will use. This is fine when the scritps stay withing my own comuter, however as soon as I want to share a script, I usual have to packagage it with all of bashful. Using gpp I can `#include "function_name.sh"` and I can compile a script that only contains the code it uses.  

## Install
* **download** the bashful\_gpp files  _tarball_   
**$**`curl -o bashful_gpp.tar.gz https://github.com/slugbyte/bashful-gpp/raw/master/bashful_gpp.tar.gz`
* **extract** the bashful\_gpp files  
**$**`tar -vxzf bashful_gpp.tar.gz`

Bashful
=======

A collection of libraries to simplify writing bash scripts.

It's separated into the following libraries:

    bashful-doc
    bashful-execute
    bashful-files
    bashful-input
    bashful-messages
    bashful-modes
    bashful-profile
    bashful-terminfo
    bashful-utils

To get full documentation on each, just invoke it at the command line with
the first argument as 'help'. For example, to get documentation on the input
library:

    bashful-input help
