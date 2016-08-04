#!/bin/bash

if [ ! -x /usr/bin/curl ]; then
    echo No curl installed!
    exit 1
fi

if [ "$1" == "" ];  then
    echo "Usage: $0 [search] [optional filter]"
    exit 1
fi
export bashstr="$(printf "curl -s --data 'str=%s&fstr=%s&ifun=if&ccg=all&search=Search' http://www.visca.com/regexdict/" "$1" "$2")"
bash -c "$bashstr" | egrep 'any matches|yourdictionary' | cut -f 2 -d '>' | cut -f 1 -d '<'

