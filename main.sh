#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

source spell_checker.sh

echo -e "\e[44mStarting main script...$NC"
echo ""
main() {
  initiate_spell_check
  check_if_travis_pr
  check_git_diff "$MARKDOWN_FILES_CHANGED"
}

main
echo ""
echo -e "\e[44mEnding main script$NC"
