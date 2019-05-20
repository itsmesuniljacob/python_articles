#!/bin/bash
# requires apt packages: aspell, aspell-en, aspell-fr

[[ "$TRAVIS_PULL_REQUEST" == "false" ]] && exit 0 # bypass script if not a pull request

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

MARKDOWN_FILES_CHANGED=`(git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep .md`

if [ -z "$MARKDOWN_FILES_CHANGED" ]
then
    echo -e "$GREEN>> No markdown file to check $NC"

    exit 0;
fi
