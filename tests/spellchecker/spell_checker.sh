#!/usr/bin/env bash
# shellcheck disable=SC2016
#RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

initiate_spell_check() {
  echo "Spellcheck module started..."
}
check_if_travis_pr() {
  [[ "$TRAVIS_PULL_REQUEST" == "false" ]] && exit 0 # bypass script if not a pull request
}

check_git_diff() {
  MARKDOWN_FILES_CHANGED=$( (git diff --name-only "$TRAVIS_COMMIT_RANGE" || true) | grep .md)
  if [ -z "$MARKDOWN_FILES_CHANGED" ]
  then
      echo -e "$GREEN>> No markdown file to check $NC"

      exit 0;
  fi
  echo -e "$BLUE>> Following markdown files were changed in this pull request (commit range: $TRAVIS_COMMIT_RANGE):$NC"
  echo "$MARKDOWN_FILES_CHANGED"
  clean_text_content "$MARKDOWN_FILES_CHANGED"
}

clean_text_content() {
  MARKDOWN_FILES_CHANGED=$1
  # cat all markdown files that changed
  TEXT_CONTENT=$(cat "$(echo "$MARKDOWN_FILES_CHANGED" | sed -E ':a;N;$!ba;s/\n/ /g')")
  # remove metadata tags
  TEXT_CONTENT=$(echo "$TEXT_CONTENT" | grep -v -E '^(layout:|permalink:|date:|date_gmt:|authors:|categories:|tags:|cover:)(.*)')
  # remove { } attributes
  TEXT_CONTENT=$(echo "$TEXT_CONTENT" | sed -E 's/\{:([^\}]+)\}//g')
  # remove html
  TEXT_CONTENT=$(echo "$TEXT_CONTENT" | sed -E 's/<([^<]+)>//g')
  # remove code blocks
  TEXT_CONTENT=$(echo "$TEXT_CONTENT" | sed -n '/```/,/```/ !p')
  # remove links
  TEXT_CONTENT=$(echo "$TEXT_CONTENT" | sed -E 's/http(s)?:\/\/([^ ]+)//g')

  echo -e "$BLUE>> Text content that will be checked (without metadata, html, and links):$NC"
  echo "$TEXT_CONTENT"
}

echo -e "\e[44mStarting main script...$NC"
echo ""

main() {
  initiate_spell_check
  check_if_travis_pr
  check_git_diff "$MARKDOWN_FILES_CHANGED"
  echo ""
  echo -e "\e[44mEnding main script$NC"
}

main
