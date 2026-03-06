#!/bin/bash
npm run build
if [ -d ../sboe0705.github.io ]; then
  rm -rf ../sboe0705.github.io/word-trainer/* && \
  mv -f dist/* ../sboe0705.github.io/word-trainer/ && \
  (
    cd ../sboe0705.github.io && \
    git add word-trainer/* && \
    git commit -m "updated word-trainer"
    if git diff --quiet && git diff --cached --quiet && [[ $(git rev-list --count origin/main..HEAD) -eq 1 ]]; then
      git push origin main
    else
      echo "uncommitted changes or more than one commit detected, skipping push"
    fi
  )
fi
