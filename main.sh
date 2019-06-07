#!/usr/bin/env bash

# shellcheck source=somefile
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
