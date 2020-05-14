#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# Extract "repo" and "branch" arguments from the input into
# REPO and BRANCH shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "REPO=\(.repo) BRANCH=\(.branch)"')"

# git sha for latest commit on branch we care about
COMMIT_SHA=$(git ls-remote "$REPO" "$BRANCH" | cut -f 1)

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg sha "$COMMIT_SHA" '{"sha":$sha}'