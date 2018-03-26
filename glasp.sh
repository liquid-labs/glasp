#!/bin/bash

ACTION=$1

if [ x"$ACTION" == x"pull" ]; then
   cp "$PWD/.glaspignore" "$PWD/.claspignore"
   # on pull, also ignore the library files, which are only pushed
   echo >> "$PWD/.claspignore"
   grep --no-filename -e '^#do-push-file' "$PWD/.glaspignore" | awk '{print $2}' >> "$PWD/.claspignore"
else
    # on all other actions, only ignore the commonly ignored files
   cp "$PWD/.glaspignore" "$PWD/.claspignore"
fi

exec clasp "$@"