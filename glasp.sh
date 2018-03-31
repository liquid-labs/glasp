#!/bin/bash

ACTION=$1

for COM in clasp git; do
    command -v $COM >/dev/null || \
        { echo "Requierd command $COM not found. Aborting." >&2; exit 1; }
done

# Check re. actions using .clasp.json
case "$ACTION" in
  import-lib)
    IMPORT_PATH="$2"
    if [ ! -d "$IMPORT_PATH" ]; then
      echo "Did not find library path '$IMPORT_PATH' for import." >&2
      exit 1
    fi
    mkdir -p lib
    for FILE in "$IMPORT_PATH"/*.js "$IMPORT_PATH"/*.html "$IMPORT_PATH/lib/"*; do
      if [ -f "$FILE" ] && [ ! -L lib/`basename "$FILE"` ]; then
        ln -s ../"$FILE" lib/
      fi
    done
    exit 0;; # otherwise, would try to run 'clasp import'
  pull|push|open|deployments|deploy|undeploy|redeploy|versions|version|import)
    if [ ! -f .clasp.json ]; then
      echo "Did not find '.clasp.json' file. Execute from clasp root directory." >&2
      exit 1
    fi
    # Safety checks.
    if [ x"$ACTION" == x"pull" ]; then
      LCOUNT=`git status --porcelain . | wc -l`
      if [ $LCOUNT -gt 0 ]; then
        echo "Found local uncommitted changes. Aborting pull." >&2
        exit 2
      fi
    fi;;
  create|clone)
    if [ -f .clasp.json ]; then
      echo "Existing '.clasp.json' found. Aborting." >&2
      exit 1
    fi;;
  *)
    echo "Unknown action '$ACTION'." >&2
    exit 3;;
esac

exec clasp "$@"
