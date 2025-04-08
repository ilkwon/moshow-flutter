#!/bin/bash

echo "🚀 Flutter Web 자동 배포 시작!"
rm -rf build/web

flutter build web
cd build/web

git init
git branch -M main
git remote add origin https://github.com/ilkwon/ilkwon.github.io.git

git add .
git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M:%S')"
git push -f origin main

echo "✅ 배포 완료! → https://ilkwon.github.io"
