#!/bin/bash

set -euxo pipefail

echo "Going to update to $1"
git fetch upstream
# This git merge is OK to fail
git merge $1 --allow-unrelated-histories --squash --strategy-option=theirs ||:
git add .
git commit -m "Merge $1"
make clean
make
git add .
git commit -m "Build $1"
./bin/npm-cli.js --version
