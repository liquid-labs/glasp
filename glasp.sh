#!/bin/bash

ACTION=$1

for COM in clasp git; do
    command -v $COM >/dev/null || \
        { echo "Requierd command $COM not found. Aborting." >&2; exit 1; }
done

# Check re. actions using .clasp.json
case "$ACTION" in
  pull|push|open|deployments|deploy|undeploy|redeploy|versions|version)
    if [ ! -f .clasp.json ]; then
      echo "Did not find '.clasp.json' file. Execute from clasp root directory." >&2
      exit 1
    fi;;
  create|clone)
    if [ -f .clasp.json ]; then
      echo "Existing '.clasp.json' found. Aborting." >&2
      exit 1
    fi;;
esac

# Safety checks.
if [ x"$ACTION" == x"pull" ]; then
  LCOUNT=`git status --porcelain . | wc -l`
  if [ $LCOUNT -gt 0 ]; then
    echo "Found local uncommitted changes. Aborting pull." >&2
    exit 2
  fi
fi

exec clasp "$@"
