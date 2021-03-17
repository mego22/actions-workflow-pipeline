#!/usr/bin/env sh

set -e -o pipefail

GIT_TOKEN="${INPUT_TOKEN}"
DISPATCHES="${INPUT_DISPATCH}"


validate_vars() {

  if [ -z "${GIT_TOKEN}" ]; then echo "::error::Password/token not set";  exit 1; fi
  if [ -z "${DISPATCHES}" ]; then echo "::error::Dispatches not set";  exit 2; fi

}

check_commands() {

  if ! command -v curl > /dev/null ; then echo "::error::Missing curl"; exit 3; fi
  if ! command -v jq > /dev/null ; then echo "::error::Missing jq"; exit 4; fi

}


trigger_dispatches() {
  for dispatch in `echo "${DISPATCHES}" | jq -c .[]`
  do
    ORG=`echo ${dispatch} | jq -r '.org'`
    REPO=`echo ${dispatch} | jq -r '.repo'`
    BRANCH=`echo ${dispatch} | jq -r '.branch'`
    WORKFLOW=`echo ${dispatch} | jq -r '.workflow'`

    _post_data(){
      cat <<EOF
      {"ref": "refs/heads/${BRANCH}"}
EOF
    }

    echo "::group::$REPO"
    echo "Triggering $WORKFLOW for $REPO."
    echo "::endgroup::"

    curl -qs \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GIT_TOKEN}" \
     https://api.github.com/repos/${ORG}/${REPO}/actions/workflows/${WORKFLOW}/dispatches \
     -d "$(_post_data)"

  done

}

main(){
  validate_vars
  check_commands

  trigger_dispatches
}

main $*
