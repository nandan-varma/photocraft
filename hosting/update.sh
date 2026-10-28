#!/usr/bin/env bash
# Sync the fork with upstream, then deploy the latest (or a given) release's web build to
# Cloudflare Workers static assets at photocraft.nandan.fyi.
#
#   hosting/update.sh [vX.Y.Z]
set -euo pipefail

cd "$(dirname "$0")"
repo=storytold/photocraft
tag=${1:-$(gh release view -R "$repo" --json tagName --jq .tagName)}
ver=${tag#v}

echo "==> Syncing fork with upstream"
git -C .. fetch upstream --tags --quiet
git -C .. merge --ff-only upstream/main --quiet || git -C .. merge --no-edit upstream/main
git -C .. push origin HEAD --quiet

echo "==> Fetching $tag"
rm -rf .download site
mkdir .download
gh release download "$tag" -R "$repo" -p "photocraft-web-$ver.zip" -D .download
unzip -q ".download/photocraft-web-$ver.zip" -d .download/unpacked
mv ".download/unpacked/photocraft-web-$ver" site
rm -rf .download
test -f site/index.html && test -f site/app/parts.txt

echo "==> Deploying $tag"
wrangler deploy --message "PhotoCraft $tag"

echo "$tag" > DEPLOYED
git -C .. add hosting/DEPLOYED
git -C .. diff --cached --quiet || git -C .. commit -qm "hosting: deploy $tag" && git -C .. push origin HEAD --quiet
echo "==> Done: https://photocraft.nandan.fyi ($tag)"
