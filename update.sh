#!/bin/bash

set -euxo pipefail

echo "Going to update to $1"

# Stash our files in memory
our_gitreview=$(cat .gitreview)
our_readme=$(cat README-Wikimedia)
our_script=$(cat update.sh)

# Wipe the whole working tree and stage its removal
git rm -rf . && git clean -dffx

# Download and extract the next version
url="https://registry.npmjs.org/npm/-/npm-$1.tgz"
curl -SsL "$url" | tar -xzf -
mv package/.[!.]* package/* . && rmdir package/
# Verify that it works
./bin/npm-cli.js --version

# Restore our files
echo "$our_gitreview" > .gitreview
echo "$our_readme" > README-Wikimedia
echo "$our_script" > update.sh
chmod +x update.sh

git add .
git commit -m "Install $1

From $url
"
