#!/usr/bin/env bash

GIT_REV="$(git rev-parse HEAD)"&& \
rm -rf dist && \
rm -rf node_modules && \
npm install && \
npm run build && \
mkdir deployment && \
cd deployment/ && \
git init && \
git remote add origin git@github.com:mradkov/aeternity-token-sale-example.git && \
git fetch && \
git checkout gh-pages && \
git rm -rf . && \
git clean -ffxd && \
cp -r ../dist/* . && \
echo "tokensale.aepps.tech" > CNAME && \
git add * && \
git commit -m "aeternity-token-sale-example ${GIT_REV} deployment to gh-pages" && \
git fetch && git rebase -s recursive -Xtheirs origin/gh-pages && \
git push origin gh-pages && \
cd .. && \
rm -rf deployment
